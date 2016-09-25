const (
    waitForP1 = 0
    waitForP2 = 1
    waitForTimeout = 2
    gameOver = 3
)

struct game {
    left int
    failedTries int

    board [nblock]char
    visible [nblock]bool
    dirty dirtyMap
    allDirty bool

    p1, p2 int
    paired bool

    state int
    startTime long.Long
    timeout long.Long
}

func (g *game) init() {
    for i := 0; i < nblock; i++ {
        g.visible[i] = false
    }
    g.dirty.clean()
    g.allDirty = true

    for i := 0; i < nblock; i++ {
        g.board[i] = 'A' + char(i / 2)
    }
    g.shuffle()
    g.setFaces()

    g.left = nblock / 2
    g.state = waitForP1
    g.failedTries = 0

    vpc.TimeElapsed(&g.startTime)
}

func (g *game) setFaces() {
    for i := 0; i < nblock; i++ {
        p := byte(i)
        table.Act(p, table.HideBack)
        table.SetFace(p, g.board[i])
    }
}

func (g *game) shuffle() {
    for i := 0; i < nblock - 1; i++ {
        step := int(misc.Rand() % uint(nblock - i))
        if step == 0 continue

        t := i + step
        g.board[t], g.board[i] = g.board[i], g.board[t]
    }
}

func (g *game) clickable(p int) bool {
    return g.board[p] != ' '
}

func (g *game) clean() {
    g.allDirty = false
    g.dirty.clean()
}

func (g *game) click(p int, valid bool) {
    if g.state == gameOver {
        g.init()
        return
    }

    if g.state == waitForP1 {
        if !valid return
        if !g.clickable(p) return
        g.p1 = p
        g.visible[p] = true
        g.state = waitForP2
        g.dirty.touch(p)
    } else if g.state == waitForP2 {
        if !valid return
        if !g.clickable(p) return
        if g.p1 == p return

        g.p2 = p
        g.visible[p] = true
        g.paired = (g.board[g.p1] == g.board[g.p2])

        g.state = waitForTimeout
        g.dirty.touch(p)

        vpc.TimeElapsed(&g.timeout)
        g.timeout.Iadd(1000000000)
    } else if g.state == waitForTimeout {
        g.dirty.touch(g.p1)
        g.dirty.touch(g.p2)

        if g.paired { // paired
            g.board[g.p1] = ' '
            g.board[g.p2] = ' '
            g.left--
            if g.left <= 0 {
                g.state = gameOver
                return
            }
        } else {
            g.visible[g.p1] = false
            g.visible[g.p2] = false
            g.failedTries++
        }
        g.state = waitForP1
    } else {
        fmt.PrintStr("entered invalid state")
        g.init()
    }
}

func (g *game) screenClick(x, y int) {
    g.click(translateClick(x, y))
}

var msgBuf [vpc.MaxLen]byte

func (g *game) handleInput() bool {
    var timeout long.Long
    timeout.Iset(200000000)

    service, n, err := vpc.Poll(&timeout, msgBuf[:])
    if err == vpc.ErrTimeout return false

    if err != 0 {
        printInt(err)
        panic()
    }
    msg := msgBuf[:n]

    if service == vpc.Screen {
        x, y, ok := screen.HandleClick(msg)
        if !ok {
            fmt.PrintStr("invalid screen click\n")
            panic()
        }

        g.click(translateClick(x, y))
        return true
    } else if service == vpc.Table {
        p, ok := table.HandleClick(msg)
        if !ok {
            fmt.PrintStr("invalid table click\n")
            panic()
        }

        if p == 255 {
            g.click(0, false)
        } else {
            g.click(int(p), true)
        }
        return true
    }

    fmt.PrintStr("unknown service input\n")
    return false
}

func (g *game) waitClick() {
    for !g.handleInput() {
        if g.state == gameOver continue

        var now long.Long
        vpc.TimeElapsed(&now)

        // draw the time in seconds
        t := now
        t.Sub(&g.startTime)
        t.Udiv1e9()
        secs := t.Ival()
        drawTime(secs)

        if g.state == waitForTimeout && now.LargerThan(&g.timeout) {
            // timeout, simulate a screen click
            g.screenClick(0, 0)
            return
        }
    }
}

func (g *game) draw() {
    if g.allDirty {
        g.drawAll()
    } else {
        g.drawDirty()
    }

    g.clean()
    g.drawStateMessage()
    g.drawStats()
}

func (g *game) drawBlock(p int) {
    x := p / height * xgrid + xoffset
    y := p % height * ygrid + yoffset
    b := g.board[p]
    p8 := uint8(p)

    if b == ' ' {
        table.Act(p8, table.HideBack)
        screen.PrintAt(x, y, '.')
    } else if g.visible[p] {
        table.Act(p8, table.ShowFront)
        screen.PrintAt(x, y, b)
    } else {
        table.Act(p8, table.ShowBack)
        screen.PrintAt(x, y, '+')
    }
}

func (g *game) drawAll() {
    for i := 0; i < width; i++ {
        for j := 0; j < height; j++ {
            g.drawBlock(i * height + j)
        }
    }
}

func (g *game) drawDirty() {
    i := 0
    for {
        p, ok := g.dirty.iter(&i)
        if !ok break
        g.drawBlock(p)
    }
}

func (g *game) drawStateMessage() {
    if g.state == waitForP1 {
        drawMessage("Click a '+' block.")
    } else if g.state == waitForP2 {
        drawMessage("Click a another '+' block.")
    } else if g.state == waitForTimeout {
        if g.paired {
            drawMessage("Paired! (click anywhere to continue)")
        } else {
            drawMessage("Mispaired. (click anywhere to continue)")
        }
    } else if g.state == gameOver {
        drawMessage("You won. (click anywhere to start a new game)")
    }
}

func (g *game) drawStats() {
    var buf [50]byte
    var stats bytes.Buffer
    stats.Init(buf[:])

    stats.WriteString("tries: ")
    fmt.FprintInt(&stats, g.failedTries)

    drawStats(stats.Bytes())
}
