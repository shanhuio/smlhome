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

    ticker time.Ticker
    clickTimer time.Timer
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

    g.ticker.Clear()
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

func (g *game) started() bool {
    return g.ticker.Running()
}

var oneSec long.Long

func init() {
    oneSec.Uset(1000000000)
}

func (g *game) clickP1(p int) {
    if !g.clickable(p) return
    g.p1 = p
    g.cards[p].showingFace = true
    g.state = waitForP2
    g.dirty.touch(p)

    if !g.ticker.Running() {
        now := timeNow()
        g.ticker.Start(&now, &oneSec)
    }
}

func (g *game) startClickTimer() {
    t := timeNow()
    t.Add(&oneSec)
    g.clickTimer.SetDeadline(&t)
}

func (g *game) clickP2(p int) {
    if g.p1 == p return

    g.p2 = p
    g.cards[p].showingFace = true
    g.paired = (g.cards[g.p1].face == g.cards[g.p2].face)

    g.state = waitForTimeout
    g.dirty.touch(p)

    g.startClickTimer()
}

func (g *game) clickResult() {
    g.dirty.touch(g.p1)
    g.dirty.touch(g.p2)
    g.clickTimer.Clear()

    if g.paired { // paired
        g.cards[g.p1].hidden = true
        g.cards[g.p2].hidden = true
        g.left--
        if g.left <= 0 {
            g.state = gameOver
            g.ticker.Stop()
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
        fmt.PrintStr("invalid state")
        g.init()
    }
}

func (g *game) forward(now *long.Long) {
    g.clickTimer.Forward(now)
    g.ticker.Forward(now)

    if g.clickTimer.Triggered() {
        g.click(0, false)
        g.clickTimer.Clear()
    }
    g.v.SetTime(g.ticker.N())
}

func (g *game) clickTimeout(next *long.Long) *long.Long {
    next.SetImax()
    ev := g.clickTimer.NextEvent(next)
    ev = g.ticker.NextEvent(next) || ev
    if !ev return nil

    var now long.Long
    vpc.TimeElapsed(&now)
    if next.LargerThan(&now) {
        next.Sub(&now)
    } else {
        next.Clear()
    }
    return next
}

var msgBuf [vpc.MaxLen]byte

func (g *game) pollClick() bool {
    var timeout long.Long

    service, n, err := vpc.Poll(g.clickTimeout(&timeout), msgBuf[:])
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

        g.click(int(p), p != 255)
        return true
    }

    fmt.PrintStr("unknown service input\n")
    return false
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
