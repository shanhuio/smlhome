const (
    waitForP1 = 0
    waitForP2 = 1
    waitForTimeout = 2
    gameOver = 3
)

struct game {
    v *view

    left int
    failedTries int

    deck [nblock]card
    cards [nblock]*card

    dirty dirtyMap
    allDirty bool

    p1, p2 int
    paired bool

    state int
    started bool
    startTime long.Long
    timeout long.Long
}

func (g *game) init() {
    for i := 0; i < nblock; i++ {
        c := &g.deck[i]
        c.face = 'A' + char(i / 2)
        c.showingFace = false
        c.hidden = false
        g.cards[i] = c
    }

    g.dirty.clean()
    g.allDirty = true

    shuffle(g.cards[:])
    g.setFaces()

    g.left = nblock / 2
    g.state = waitForP1
    g.failedTries = 0
    g.started = false
    g.v = &theView
}

func (g *game) setFaces() {
    for i := 0; i < nblock; i++ {
        p := byte(i)
        table.Act(p, table.HideBack)
        table.SetFace(p, g.cards[i].face)
    }
}

func (g *game) clickable(p int) bool {
    return !g.cards[p].hidden
}

func (g *game) clean() {
    g.allDirty = false
    g.dirty.clean()
}

func (g *game) clickP1(p int) {
    if !g.clickable(p) return
    g.p1 = p
    g.cards[p].showingFace = true
    g.state = waitForP2
    g.dirty.touch(p)
    if !g.started {
        g.started = true
        vpc.TimeElapsed(&g.startTime)
    }
}

func (g *game) clickP2(p int) {
    if g.p1 == p return

    g.p2 = p
    g.cards[p].showingFace = true
    g.paired = (g.cards[g.p1].face == g.cards[g.p2].face)

    g.state = waitForTimeout
    g.dirty.touch(p)

    vpc.TimeElapsed(&g.timeout)
    g.timeout.Iadd(1000000000)
}

func (g *game) clickResult() {
    g.dirty.touch(g.p1)
    g.dirty.touch(g.p2)

    if g.paired { // paired
        g.cards[g.p1].hidden = true
        g.cards[g.p2].hidden = true
        g.left--
        if g.left <= 0 {
            g.state = gameOver
            return
        }
    } else {
        g.cards[g.p1].showingFace = false
        g.cards[g.p2].showingFace = false
        g.failedTries++
    }
    g.state = waitForP1
}

func (g *game) click(p int, valid bool) {
    if g.state == gameOver {
        g.init()
        return
    }

    if g.state == waitForP1 {
        if !valid return
        g.clickP1(p)
    } else if g.state == waitForP2 {
        if !valid return
        if !g.clickable(p) return
        g.clickP2(p)
    } else if g.state == waitForTimeout {
        g.clickResult()
        if valid {
            g.clickP1(p)
        }
    } else {
        fmt.PrintStr("entered invalid state")
        g.init()
    }
}

var msgBuf [vpc.MaxLen]byte

var tframe long.Long

func init() {
    tframe.Iset(200000000) // TODO: need var init or struct literal
}

func (g *game) handleInput() bool {
    var timeout *long.Long
    if g.started && g.state != gameOver {
        timeout = &tframe
    }

    service, n, err := vpc.Poll(timeout, msgBuf[:])
    if err == vpc.ErrTimeout return false

    if err != 0 {
        printInt(err)
        panic()
    }
    msg := msgBuf[:n]

    if service == vpc.Table {
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
        if !g.started {
            g.v.SetTime(0)
        } else {
            t := now
            t.Sub(&g.startTime)
            t.Udiv1e9()
            secs := t.Ival()
            g.v.SetTime(secs)

            if g.state == waitForTimeout && now.LargerThan(&g.timeout) {
                // timeout, simulate a screen click
                g.click(0, false)
                return
            }
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
    g.v.SetMessage(g.stateMessage())
    g.drawStats()
}

func (g *game) drawBlock(p int) {
    c := g.cards[p]
    p8 := uint8(p)

    if c.hidden {
        table.Act(p8, table.HideBack)
    } else if c.showingFace {
        table.Act(p8, table.ShowFront)
    } else {
        table.Act(p8, table.ShowBack)
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

func (g *game) stateMessage() string {
    if g.state == waitForP1 return "Click a card."
    if g.state == waitForP2 return "Click a another card."

    if g.state == waitForTimeout {
        if g.paired return "Paired!"
        return "Mispaired."
    }
    if g.state == gameOver return "You won!"
    return ""
}

func (g *game) drawStats() {
    var buf [50]byte
    var stats bytes.Buffer
    stats.Init(buf[:])

    stats.WriteString("failed tries: ")
    fmt.FprintInt(&stats, g.failedTries)

    g.v.SetStats(stats.Bytes())
}
