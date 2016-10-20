const (
    waitForP1 = 0
    waitForP2 = 1
    waitForTimeout = 2
    gameOver = 3
)

struct game {
    r render
    deck [nblock]card

    cards [nblock]*card
    left int
    failedTries int

    p1, p2 int
    paired bool

    state int

    needRedraw bool
    ticker time.Ticker
    clickTimer time.Timer
}

func (g *game) init() {
    g.r.init()
    g.reset()
    g.redraw()
}

func (g *game) redraw() {
    g.needRedraw = true
}

func (g *game) reset() {
    for i := 0; i < nblock; i++ {
        c := &g.deck[i]
        g.cards[i] = c
        c.face = 'A' + char(i / 2)
        c.faceUp = false
    }

    shuffle(g.cards[:])

    g.left = nblock / 2
    g.state = waitForP1
    g.failedTries = 0
    g.ticker.Clear()
    g.redraw()
}

func (g *game) message() string {
    if g.state == waitForP1 return "Click a card."
    if g.state == waitForP2 return "Click a another card."
    if g.state == waitForTimeout {
        if g.paired return "Paired!"
        return "Mispaired."
    }
    if g.state == gameOver return "You won!"
    panic()
    return ""
}

func (g *game) render() {
    if !g.needRedraw return

    var prop renderProp
    prop.message = g.message()
    prop.cards = g.cards[:]
    prop.failedTries = g.failedTries
    prop.nsecond = g.ticker.N()

    g.r.render(&prop)
    g.needRedraw = false
}

func (g *game) clickable(p int) bool {
    return g.cards[p] != nil
}

func (g *game) started() bool {
    return g.ticker.Running()
}

func (g *game) clickP1(p int) {
    if !g.clickable(p) return
    g.p1 = p
    g.cards[p].faceUp = true
    g.state = waitForP2

    if !g.started() { // first click, game starts.
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
    if !g.clickable(p) return
    if g.p1 == p return

    g.p2 = p
    c := g.cards[p]
    c.faceUp = true
    g.paired = (g.cards[g.p1].face == c.face)
    g.state = waitForTimeout
    g.startClickTimer()
}

func (g *game) clickResult() {
    g.clickTimer.Clear()

    if g.paired { // paired
        g.cards[g.p1] = nil
        g.cards[g.p2] = nil
        g.left--
        if g.left <= 0 {
            g.state = gameOver
            g.ticker.Stop()
            return
        }
    } else {
        g.cards[g.p1].faceUp = false
        g.cards[g.p2].faceUp = false
        g.failedTries++
    }
    g.state = waitForP1
}

func (g *game) click(p int, onCard bool) {
    if g.state == gameOver {
        g.reset()
        return
    }

    if g.state == waitForP1 {
        if !onCard return
        g.clickP1(p)
    } else if g.state == waitForP2 {
        if !onCard return
        g.clickP2(p)
    } else if g.state == waitForTimeout {
        g.clickResult()
        if onCard {
            g.clickP1(p)
        }
    } else {
        fmt.PrintStr("invalid state")
        panic()
    }
    g.redraw()
}

func (g *game) dispatch() {
    var s selector
    ev := s.Select(&g.ticker, &g.clickTimer)
    if ev == eventNothing return

    if ev == eventTicker {
        g.redraw() // need redraw the play time counter
    } else if ev == eventTimer {
        if g.state == waitForTimeout {
            g.clickResult()
            g.redraw()
        }
    } else if ev == eventClick {
        g.click(s.LastClick())
    } else {
        fmt.PrintStr("invalid event received")
    }
}
