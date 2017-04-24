struct line {
    r1, c1 int
    r2, c2 int
    visible bool

    div table.Div
}

func (ln *line) init(k uint8) {
    d := &ln.div
    d.Key = k
    d.BackgroundColor = lineColor
    d.ZIndex = 1
    d.BorderRadius = 1
}

func (ln *line) show(r1, c1, r2, c2 int) {
    ln.visible = true
    ln.r1, ln.c1 = r1, c1
    ln.r2, ln.c2 = r2, c2
}

func (ln *line) hide() {
    ln.visible = false
}

func (ln *line) render(show bool) *table.Div {
    d := &ln.div
    if !ln.visible || !show {
        d.Visible = false
        return d
    }

    d.Visible = true
    if ln.r1 == ln.r2 {
        c1, c2 := ln.c1, ln.c2
        if c1 > c2 {
            c1, c2 = c2, c1
        }
        left1, top1 := renderCenterPos(ln.r1, c1)
        d.Left = left1 - 1
        d.Top = top1 - 1
        d.Height = 2
        left2 := renderCenterLeft(c2)
        d.Width = left2 - left1 + 2
    } else if ln.c1 == ln.c2 {
        r1, r2 := ln.r1, ln.r2
        if r1 > r2 {
            r1, r2 = r2, r1
        }
        left1, top1 := renderCenterPos(r1, ln.c1)
        d.Left = left1 - 1
        d.Top = top1 - 1
        d.Width = 2
        top2 := renderCenterTop(r2)
        d.Height = top2 - top1 + 2
    } else {
        d.Visible = false
    }

    return d
}
