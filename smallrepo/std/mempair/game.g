const (
    width = 4
    height = 6

    nblock = width * height
)

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

    dirtyMap [nblock]bool
    dirtyBuf [nblock]int
    ndirty int
    allDirty bool

    p1, p2 int
    paired bool

    ntries int
    state int
}

func (g *game) init() {
    for i := 0; i < nblock; i++ {
        g.visible[i] = false
        g.dirtyMap[i] = false
    }
    g.ndirty = 0
    g.allDirty = true

    for i := 0; i < nblock; i++ {
        g.board[i] = 'A' + char(i / 2)
    }
    g.shuffle()

    g.left = nblock / 2
    g.state = waitForP1
    g.failedTries = 0
}

func (g *game) shuffle() {
    for i := 0; i < nblock - 1; i++ {
        step := int(misc.Rand() % uint(nblock - i))
        if step == 0 {
            continue
        }

        t := i + step
        g.board[t], g.board[i] = g.board[i], g.board[t]
    }
}

func (g *game) clickable(p int) bool {
    return g.board[p] != ' '
}

func (g *game) touch(p int) {
    if g.dirtyMap[p] return
    g.dirtyMap[p] = true
    g.dirtyBuf[g.ndirty] = p
    g.ndirty++
}

func (g *game) clean() {
    g.allDirty = false
    for i := 0; i < g.ndirty; i++ {
        p := g.dirtyBuf[i]
        g.dirtyMap[p] = false
    }
    g.ndirty = 0
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
        g.touch(p)
    } else if g.state == waitForP2 {
        if !valid return
        if !g.clickable(p) return
        if g.p1 == p return

        g.p2 = p
        g.visible[p] = true
        g.paired = (g.board[g.p1] == g.board[g.p2])

        g.state = waitForTimeout
        g.touch(p)
    } else if g.state == waitForTimeout {
        g.touch(g.p1)
        g.touch(g.p2)

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
        return
    }
}

const (
    xoffset = 5
    yoffset = 20
    xgrid = 2
    ygrid = 4
)

func translateClick(x, y int) (int, bool) {
    if x < xoffset return 0, false
    if y < yoffset return 0, false
    x -= xoffset
    y -= yoffset
    if x % xgrid != 0 return 0, false
    if y % ygrid != 0 return 0, false
    x /= xgrid
    y /= ygrid
    if x >= width return 0, false
    if y >= height return 0, false
    return x * height + y, true
}

func (g *game) screenClick(x, y int) {
    g.click(translateClick(x, y))
}

func (g *game) waitClick() {
    g.screenClick(screen.WaitClick())
}

func drawMessage(s string) {
    for i := 0; i < 50; i++ {
        screen.PrintAt(xoffset - 2, yoffset + i, ' ')
    }
    screen.PrintStrAt(xoffset - 2, yoffset, s)
}

func drawStats(bs []byte) {
    for i := 0; i < 50; i++ {
        screen.PrintAt(xoffset + 10, yoffset + i, ' ')
    }
    for i := 0; i < len(bs); i++ {
        screen.PrintAt(xoffset + 10, yoffset + i, char(bs[i]))
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

func (g *game) drawAll() {
    for i := 0; i < width; i++ {
        x := xoffset + i * xgrid
        for j := 0; j < height; j++ {
            y := yoffset + j * ygrid
            p := i * height + j
            b := g.board[p]
            if b == ' ' {
                screen.PrintAt(x, y, '.')
            } else if g.visible[p] {
                screen.PrintAt(x, y, b)
            } else {
                screen.PrintAt(x, y, '+')
            }
        }
    }
}

func (g *game) drawDirty() {
    for i := 0; i < g.ndirty; i++ {
        p := g.dirtyBuf[i]
        x := p / height * xgrid + xoffset
        y := p % height * ygrid + yoffset
        b := g.board[p]
        if b == ' ' {
            screen.PrintAt(x, y, '.')
        } else if g.visible[p] {
            screen.PrintAt(x, y, b)
        } else {
            screen.PrintAt(x, y, '+')
        }
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
