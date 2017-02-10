struct piece {
    valid bool
    row, col uint8
    value uint8
    toDouble bool
    newBorn bool

    box *canvas.Box
}

func (p *piece) init(b *canvas.Box) {
    p.box = b
}

func (p *piece) render() *canvas.Box {
    b := p.box
    b.Left = 30 + 100 * int(p.col)
    b.Top = 30 + 100 * int(p.row)
    b.ClassID = faceClassID(p.value)

    return b
}
