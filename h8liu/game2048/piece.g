const (
    leftMargin = 50
    topMargin = 80
    gridSize = 90
)

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
    b.Left = leftMargin + gridSize * int(p.col)
    b.Top = topMargin + gridSize * int(p.row)
    b.ClassID = faceClassID(p.value)

    return b
}
