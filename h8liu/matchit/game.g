const (
    waitP1 = 0
    waitP2 = 1
    waitGap = 2
    gameOver = 3
)

struct game {
    blockBuf [nblock]block
    blocks [nblock]*block

    nvisible int
    state int
    p1, p2 int
    lines [3]line

    timer time.Timer
    gapInterval long.Long

    // for drawing the lines
    selectDiv1 table.Div
    selectDiv2 table.Div
}

func initSelectDiv(d *table.Div, k uint8) {
    d.Key = k
    d.BackgroundColor = 0x111111
    d.Width = 44
    d.Height = 44
    d.BorderRadius = 5
    d.ZIndex = 1
}

func initLineDiv(d *table.Div) {
    d.BackgroundColor = 0x111111
    d.ZIndex = 1
    d.BorderRadius = 1
}

// init sets up the game
func (g *game) init() {
    g.gapInterval.Iset(200000000)

    initSelectDiv(&g.selectDiv1, uint8(nblock))
    initSelectDiv(&g.selectDiv2, uint8(nblock + 1))

    n := len(g.lines)
    for i := 0; i < n; i++ {
        g.lines[i].init(uint8(nblock + 2 + i))
    }

    for i := 0; i < nblock; i++ {
        b := &g.blockBuf[i]
        g.blocks[i] = b
        b.init((i / 4) % ncolor)
    }

    g.reset()
}

func (g *game) reset() {
    for i := 0; i < nblock; i++ {
        g.blocks[i].visible = true
    }
    g.nvisible = nblock
    g.state = waitP1
    shuffle(g.blocks[:])
}

func (g *game) renderSelect1() *table.Div {
    d := &g.selectDiv1
    d.Visible = g.state == waitP2 || g.state == waitGap

    if d.Visible {
        d.Left, d.Top = renderSelectPos(rowCol(g.p1))
    }
    return d
}

func (g *game) renderSelect2() *table.Div {
    d := &g.selectDiv2
    d.Visible = g.state == waitGap
    if d.Visible {
        d.Left, d.Top = renderSelectPos(rowCol(g.p2))
    }
    return d
}

func (g *game) render() {
    var divs [nblock + 5]*table.Div

    for i := 0; i < nblock; i++ {
        divs[i] = g.blocks[i].render(i)
    }

    extras := divs[nblock:]
    extras[0] = g.renderSelect1()
    extras[1] = g.renderSelect2()

    showLines := g.state == waitGap
    extras[2] = g.lines[0].render(showLines)
    extras[3] = g.lines[1].render(showLines)
    extras[4] = g.lines[2].render(showLines)

    var prop table.Prop
    prop.Divs = divs[:]
    table.Render(&prop)
}

func (g *game) matchCheck(p1, p2 int) (int, int, bool) {
    return 0, 0, true
}

func (g *game) handleP1(pos int) {
    g.p1 = pos
    g.state = waitP2
}

// returns true if pos is a valid one
func (g *game) handleP2(pos int) {
    if pos == g.p1 { // cancel the selection
        g.state = waitP1
        return
    }

    b1 := g.blocks[g.p1]
    b2 := g.blocks[pos]
    if b1.color != b2.color { // not a match, re-select
        g.p1 = pos
        return
    }

    // TODO: draw the connecting line
    r1, c1, r2, c2, ok := matchCheck(g.blocks[:], g.p1, pos)
    if !ok {
        g.p1 = pos
        return
    }

    g.p2 = pos
    rFrom, cFrom := rowCol(g.p1)
    rTo, cTo := rowCol(pos)
    if !(rFrom == r1 && cFrom == c1) {
        g.lines[0].show(rFrom, cFrom, r1, c1)
    } else {
        g.lines[0].hide()
    }
    g.lines[1].show(r1, c1, r2, c2)
    if !(rTo == r2 && cTo == c2) {
        g.lines[2].show(r2, c2, rTo, cTo)
    } else {
        g.lines[2].hide()
    }

    g.state = waitGap

    t := time.Now()
    t.Add(&g.gapInterval)
    g.timer.SetDeadline(&t)
}

func (g *game) handleGap(pos int) {
    g.timer.Clear()

    g.blocks[g.p1].visible = false
    g.blocks[g.p2].visible = false
    g.nvisible -= 2

    if g.nvisible == 0 {
        g.state = gameOver
    } else {
        g.state = waitP1
    }

    if pos >= 0 && g.blocks[pos].visible {
        g.handleP1(pos)
    }
}

func (g *game) run() {
    var s events.Selector

    for g.state != gameOver {
        g.render()

        for {
            ev := s.Select(nil, &g.timer)
            if ev == events.Timer && g.state == waitGap {
                g.handleGap(-1)
                break
            }
            if ev == events.Click {
                what, pos := s.LastClick()
                if what != table.OnDiv continue
                if pos >= nblock continue
                assert(g.blocks[pos].visible)

                if g.state == waitP1 {
                    g.handleP1(pos)
                } else if g.state == waitP2 {
                    g.handleP2(pos)
                } else if g.state == waitGap {
                    g.handleGap(pos)
                } else {
                    panic()
                }
                break
            }
        }
    }

    g.render()
}
