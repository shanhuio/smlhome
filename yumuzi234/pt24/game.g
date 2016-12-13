// var i2aBuf [6][8]byte

var oneSec long.Long

const (
    expLimit = 20
    p1 = 20
    p2 = 40
    // p1,p2 to divide the memory space into three parts
    totalSpace = 100
)

func init() {
    oneSec.Uset(1000000000)
}

struct game {
    space [totalSpace]byte
    back bool
    needRedraw bool
    exp bytes.Buffer
    nums [4]int
    posInExp [4]int
    posUsed [4]int
    used int

    win bool
    score int
    timeUsed int
    expLen int
    prop table.Prop
    ticker time.Ticker
}

func (g *game) init() {
    g.exp.Init(g.space[p2:])
    g.prop.Cards[16].Face = 'C'
    g.prop.Cards[17].Face = 'R'
    g.prop.Cards[18].Face = '+'
    g.prop.Cards[19].Face = '-'
    g.prop.Cards[20].Face = '*'
    g.prop.Cards[21].Face = '/'
    g.prop.Cards[22].Face = '('
    g.prop.Cards[23].Face = ')'
    for i := 16; i < 24; i++ {
        g.prop.Cards[i].Visible = true
        g.prop.Cards[i].FaceUp = true
    }
    g.prop.Buttons[0].Visible = true
    g.prop.Buttons[1].Visible = true
    g.prop.Buttons[0].Text = "Skip"
    g.prop.Buttons[1].Text = "Return"
    now := time.Now()
    g.ticker.Start(&now, &oneSec)
    g.reset()
}

func (g *game) Run() {
    g.init()
    g.render()
    for !g.back {
        g.dispatch()
        g.render()
    }
}

func (g *game) reset() {
    var r rand.Rand
    r.RandInit()
    for i := 0; i < 4; i++ {
        n := r.IntN(9) + 1
        g.nums[i] = n
        g.prop.Cards[i + 1].Face = '0' + char(n)
        g.prop.Cards[i + 1].Visible = true
        g.prop.Cards[i + 1].FaceUp = true
    }
    g.prop.Texts[4] = ""
    g.exp.Reset()
    g.needRedraw = true
    g.prop.Buttons[0].Text = "Skip"
    g.used = 0
    g.win = false
}

func (g *game) getTime() string {
    var buf bytes.Buffer
    buf.Init(g.space[:p1])
    buf.WriteString("Time used ")
    fmt.FprintInt(&buf, g.timeUsed)
    return buf.String()
}

func (g *game) getScore() string {
    var buf bytes.Buffer
    buf.Init(g.space[p1:p2])
    buf.WriteString("Score ")
    fmt.FprintInt(&buf, g.score)
    return buf.String()
}

func (g *game) render() {
    if !g.needRedraw return

    g.timeUsed = g.ticker.N()
    g.prop.Texts[0] = g.getTime()
    g.prop.Texts[1] = g.getScore()
    g.prop.Texts[2] = g.exp.String()
    table.Render(&g.prop)
    g.needRedraw = false
}

func (g *game) dispatch() {
    var s events.Selector
    ev := s.Select(&g.ticker, nil)
    if ev == events.Nothing return
    if ev == events.Ticker {
        g.needRedraw = true
    } else if ev == events.Click {
        what, pos := s.LastClick()
        if what == table.OnCard && !g.win {
            g.clickCard(pos)
        } else if what == table.OnButton {
            if pos == 0 {
                g.reset()
            } else if pos == 1 {
                g.back = true
            }
        } else if what == table.OnTable && g.win {
            g.reset()
        }
    }
}

func (g *game) clickCard(pos int) {
    c := &g.prop.Cards[pos]
    if c.FaceUp == false {
        return
    }
    g.needRedraw = true
    if pos == 17 {
        g.exp.UnreadByte()
        g.prop.Texts[4] = " "
        if g.used != 0 && g.exp.Len() == g.posInExp[g.used - 1] {
            g.prop.Cards[g.posUsed[g.used - 1]].FaceUp = true
            g.used--
        }
        return
    }
    if pos == 16 {
        g.calculate()
        return
    }
    if g.exp.Len() == 20 {
        g.prop.Texts[4] = "Expression too long, press R to backspace"
        return
    }

    if pos >= 1 && pos <= 4 {
        c.FaceUp = false
        g.posInExp[g.used] = g.exp.Len()
        g.posUsed[g.used] = pos
        g.used++
    }
    g.exp.WriteChar(c.Face)
    g.prop.Texts[4] = ""

    g.check()
}

func (g *game) check() {
    res, valid := parse24(g.exp.String())
    if !valid return
    for i := 1; i <= 4; i++ {
        if g.prop.Cards[i].FaceUp return
    }

    if !res.EqualsInt(24) return
    g.score++
    g.prop.Texts[4] = "Found 24, Yeah~~~"
    g.prop.Buttons[0].Text = "Next"
    g.win = true
    return
}

func (g *game) calculate() {
    res, valid := parse24(g.exp.String())
    if !valid {
        g.prop.Texts[4] = "Invalid expression"
        return
    }
    for i := 1; i <= 4; i++ {
        if g.prop.Cards[i].FaceUp {
            g.prop.Texts[4] = "Need to use All cards"
            return
        }
    }
    if res.EqualsInt(24) {
        g.score++
        g.prop.Texts[4] = "Found 24, Yeah~~~"
        g.prop.Buttons[0].Text = "Next"
        g.win = true
        return
    }
    g.prop.Texts[4] = "The anwer is not correct"
}
