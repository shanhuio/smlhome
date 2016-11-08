struct game {
    c *config
    r render

    deck [nblock]card
    cards [nblock]*card

    left int
    failedTries int
    bonusTime int

    p1, p2 int
    paired bool
    pairedFace char

    state int

    needRedraw bool
    ticker time.Ticker
    clickTimer time.Timer
}

func (g *game) init(c *config) {
    g.c = c
    g.r.init()
    g.reset()
}

func (g *game) redraw() {
    g.needRedraw = true
}

func (g *game) reset() {
    for i := 0; i < nblock; i++ {
        c := &g.deck[i]
        g.cards[i] = c
        c.faceUp = false
    }

    setup(g.c, g.cards[:])

    g.left = nblock / 2
    g.state = waitForP1
    g.failedTries = 0
    g.bonusTime = 0
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
    if g.state == gameWin return "You won!"
    if g.state == gameLost return "You lost."
    panic()
    return ""
}

func (g *game) render() {
    if !g.needRedraw return

    var prop renderProp
    prop.message = g.message()
    prop.cards = g.cards[:]
    prop.failedTries = g.failedTries
    prop.failLimit = g.c.failLimit
    prop.nsecond = g.ticker.N()

    if g.c.timeLimit > 0 {
        limit := g.timeLimit()
        prop.countDown = true
        prop.nsecond = limit - prop.nsecond
        if prop.nsecond < 0 {
            prop.timeout = true
        }
    }

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
        now := time.Now()
        g.ticker.Start(&now, &oneSec)
    }
}

func (g *game) startClickTimer() {
    t := time.Now()
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
    if g.c.findSpecial {
        g.paired = g.paired && (c.face == '*')
    }
    if g.paired {
        g.pairedFace = c.face
    }
    g.state = waitForTimeout
    g.startClickTimer()
    g.pairCheck()
}

func (g *game) failedTry() {
    g.failedTries++
    if g.c.failLimit > 0 && g.failedTries >= g.c.failLimit {
        g.state = gameLost
        return
    }
}

func (g *game) pairCheck() {
    if !g.paired {
        g.failedTry()
        return
    }

    if g.c.findSpecial {
        g.ticker.Stop()
        return
    }

    g.left--
    if g.left <= 0 {
        g.ticker.Stop()
    }
    face := g.pairedFace
    if face >= 'X' && face <= 'Z' {
        g.bonusTime += 10
    }
}

func (g *game) clickResult() {
    g.clickTimer.Clear()

    if g.paired {
        g.cards[g.p1] = nil
        g.cards[g.p2] = nil
    } else {
        g.cards[g.p1].faceUp = false
        g.cards[g.p2].faceUp = false
    }

    if g.left <= 0 || (g.c.findSpecial && g.paired) {
        g.state = gameWin
        return
    }
    g.state = waitForP1
}

func (g *game) click(p int, onCard bool) {
    if g.over() return

    if g.state == waitForP1 {
        if !onCard return
        g.clickP1(p)
    } else if g.state == waitForP2 {
        if !onCard return
        g.clickP2(p)
    } else if g.state == waitForTimeout {
        g.clickResult()
        if onCard && !g.over() {
            g.clickP1(p)
        }
    } else {
        fmt.PrintStr("invalid state")
        panic()
    }
    g.redraw()
}

func (g *game) timeLimit() int {
    return g.c.timeLimit + g.bonusTime
}

func (g *game) dispatch() {
    var s events.Selector
    ev := s.Select(&g.ticker, &g.clickTimer)
    if ev == events.Nothing return

    if ev == events.Ticker {
        limit := g.timeLimit()
        if limit > 0 {
            nsec := g.ticker.N()
            if nsec > limit {
                g.state = gameLost
            }
        }
        g.redraw() // need redraw the play time counter
    } else if ev == events.Timer {
        if g.state == waitForTimeout {
            g.clickResult()
            g.redraw()
        }
    } else if ev == events.Click {
        g.click(s.LastClick())
    } else {
        fmt.PrintStr("invalid event received\n")
    }
}

func (g *game) over() bool {
    return g.state == gameWin || g.state == gameLost
}

func (g *game) run() bool {
    g.reset()
    g.render()

    for !g.over() {
        g.dispatch()
        g.render()
    }

    return g.state == gameWin
}
