struct block {
    visible bool
    color int

    div table.Div
}

func (b *block) init(color int) {
    b.color = color
    b.visible = true

    d := &b.div
    d.Width = 40
    d.Height = 40
    d.BorderRadius = 3
    d.Visible = true
    d.FontSize = 24
    d.ZIndex = 2
    d.BackgroundColor = bgColors[color]
}

func (b *block) render(pos int) *table.Div {
    d := &b.div
    d.Key = uint8(pos)

    if !b.visible {
        d.Visible = false
        return d
    }

    d.Visible = true
    d.Left, d.Top = renderPos(rowCol(pos))

    return d
}
