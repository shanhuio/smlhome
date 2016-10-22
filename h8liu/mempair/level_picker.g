const nlevel = 5

const (
    statePicking = 0
    statePicked = 1
    stateDisappearing = 2
    stateDone = 3
)

struct levelPicker {
    level int
    reached int

    state int
    timer time.Timer
}

func (p *levelPicker) init() {
    p.state = statePicking
    p.timer.Clear()
}

func (p *levelPicker) render() {
    var prop table.Prop

    if p.state == statePicking {
        prop.Texts[0] = "Pick a level."
        for i := 0; i < nlevel; i++ {
            c := &prop.Cards[i]
            c.Visible = true
            c.Face = '1' + char(i)
            if i <= p.reached {
                c.FaceUp = true
            }
        }
    } else if p.state == statePicked {
        c := &prop.Cards[p.level]
        c.Visible = true
        c.Face = '1' + char(p.level)
        c.FaceUp = true
    }

    table.Render(&prop)
}

func (p *levelPicker) waitAWhile() {
    t := timeNow()
    t.Add(&aWhile)
    p.timer.SetDeadline(&t)
}

func (p *levelPicker) dispatch() {
    var s selector
    ev := s.Select(nil, &p.timer)
    if ev == eventNothing return

    if ev == eventClick {
        if p.state == statePicking {
            pos, ok := s.LastClick()
            if ok && pos < nlevel && pos <= p.reached {
                p.state = statePicked
                p.level = pos
                p.waitAWhile()
            }
        }
    } else if ev == eventTimer {
        if p.state == statePicked {
            p.state = stateDisappearing
            p.waitAWhile()
        } else if p.state == stateDisappearing {
            p.state = stateDone
        }
    }
}

func (p *levelPicker) done() bool {
    return p.state == stateDone
}

func (p *levelPicker) reach(i int) {
    if i > p.reached {
        p.reached = i
    }
}

func (p *levelPicker) pick() int {
    p.init()
    p.render()

    for !p.done() {
        p.dispatch()
        p.render()
    }

    fmt.PrintInt(p.level)
    fmt.PrintStr("\n")
    return p.level
}
