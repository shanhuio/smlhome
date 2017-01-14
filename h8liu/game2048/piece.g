struct piece {
    valid bool
    row, col uint8
    value uint8
    toDouble bool
    newBorn bool

    div table.Div
}

func (p *piece) init(key uint8) {
    d := &p.div
    d.Key = key
    d.Width = 80
    d.Height = 80
    d.BorderRadius = 3
    d.Visible = true
    d.Transition = 120
}

func (p *piece) render() *table.Div {
    ret := &p.div
    ret.Left = 30 + 100 * int(p.col)
    ret.Top = 30 + 100 * int(p.row)

    if p.value < uint8(len(pieceFaces)) {
        f := &pieceFaces[p.value]
        ret.Text = f.text
        ret.Color = f.color
        ret.BackgroundColor = f.background
        ret.FontSize = f.fontSize
    } else {
        ret.Text = "HUGE"
        ret.Color = 0x990000
        ret.BackgroundColor = 0xffffff
        ret.FontSize = 20
    }

    return ret
}
