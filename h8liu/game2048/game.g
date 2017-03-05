var msgClass *canvas.BoxClass

func initMsgClass() {
    msgClass = canvas.AllocBoxClass()
    c := msgClass
    c.BorderRadius = 3
    c.Background = 0xf0f0f0
    c.Foreground = 0x666666
    c.FontSize = 25
    c.Width = 240
    c.Height = 40

    canvas.UpdateBoxClass(msgClass)
}

struct game {
    cells [size * size]*piece
    bgCells [size * size]*piece
    pool piecePool

    msg *canvas.Box

    won bool
    lost bool
}

func (g *game) init() {
    g.pool.init()

    b := canvas.AllocBox()
    b.ClassID = msgClass.ID()
    b.Left = 100
    b.Top = 15
    b.Text = ""
    g.msg = b
}

func (g *game) destroy() {
    // TODO: also free pieces
    canvas.FreeBox(g.msg)
}

func index(row, col int) int {
    return row * size + col
}

func (g *game) cell(row, col int) *piece {
    return g.cells[index(row, col)]
}

func (g *game) setCell(row, col int, p *piece) {
    if p != nil {
        p.row = uint8(row)
        p.col = uint8(col)
    }
    g.cells[index(row, col)] = p
}

func (g *game) setBgCell(row, col int, p *piece) {
    if p != nil {
        p.row = uint8(row)
        p.col = uint8(col)
    }
    g.bgCells[index(row, col)] = p
}

func (g *game) row(row int, buf []*piece) []*piece {
    n := 0

    for i := 0; i < size; i++ {
        c := g.cell(row, i)
        buf[n] = c
        n++
    }
    return buf[:n]
}

func (g *game) col(col int, buf []*piece) []*piece {
    n := 0

    for i := 0; i < size; i++ {
        c := g.cell(i, col)
        buf[n] = c
        n++
    }
    return buf[:n]
}

func (g *game) setRow(row int, cells, bg []*piece) {
    for i := 0; i < size; i++ {
        g.setCell(row, i, cells[i])
        g.setBgCell(row, i, bg[i])
    }
}

func (g *game) setCol(col int, cells, bg []*piece) {
    for i := 0; i < size; i++ {
        g.setCell(i, col, cells[i])
        g.setBgCell(i, col, bg[i])
    }
}

func (g *game) freeBg() {
    for i := 0; i < size * size; i++ {
        c := g.bgCells[i]
        if c == nil continue
        g.bgCells[i] = nil
        g.pool.free(c)
    }
}

func (g *game) move(k uint8) bool {
    var buf [size][size]*piece
    var bgBuf [size][size]*piece
    var lines [size][]*piece

    if k == keycode.Up || k == keycode.Down {
        ok := false
        for i := 0; i < size; i++ {
            line := g.col(i, buf[i][:])
            if merge(line, bgBuf[i][:], k == keycode.Down) {
                ok = true
            }
            lines[i] = line
        }

        if !ok return false
        for i := 0; i < size; i++ {
            line := lines[i]
            g.setCol(i, line, bgBuf[i][:])
        }
        return true
    } else if k == keycode.Left || k == keycode.Right {
        ok := false
        for i := 0; i < size; i++ {
            line := g.row(i, buf[i][:])
            if merge(line, bgBuf[i][:], k == keycode.Right) {
                ok = true
            }
            lines[i] = line
        }

        if !ok return false
        for i := 0; i < size; i++ {
            line := lines[i]
            g.setRow(i, line, bgBuf[i][:])
        }
        return true
    }
    return false
}

func (g *game) spawn() bool {
    var blanks [size * size]int
    nblank := 0
    max := uint8(0)
    for i := 0; i < size * size; i++ {
        c := g.cells[i]
        if c == nil {
            blanks[nblank] = i
            nblank++
            continue
        }
        v := c.value
        if v > max {
            max = v
        }
    }
    if nblank == 0 return false

    const winningMax = 11
    if max == winningMax {
        g.won = true
        return false
    }

    n := rand.IntN(nblank)
    pos := uint8(blanks[n])
    c := g.pool.alloc(pos / size, pos % size, newValue())
    g.cells[pos] = c
    return true
}

func (g *game) double() {
    for i := 0; i < size * size; i++ {
        c := g.cells[i]
        if c == nil continue
        if c.toDouble {
            c.toDouble = false
            c.value++
        }
    }
}

func newValue() uint8 {
    if rand.IntN(5) == 0 return 2
    return 1
}

func (g *game) render(step int) {
    var boxes canvas.BoxArray

    const n = size * size
    for i := 0; i < n; i++ {
        c := g.cells[i]
        if c == nil continue
        b := c.render()
        b.ZIndex = 2

        if c.newBorn {
            if step == 0 continue
            c.newBorn = false
        }
        boxes.Append(b)
    }

    for i := 0; i < n; i++ {
        c := g.bgCells[i]
        if c == nil continue
        b := c.render()
        b.ZIndex = 1
        if step == 1 continue
        boxes.Append(b)
    }

    if g.won {
        g.msg.Text = "You won!"
    } else if g.lost {
        g.msg.Text = "No move. Game over."
    } else {
        g.msg.Text = "Try to get 2048."
    }

    boxes.Append(g.msg)

    canvas.Render(&boxes)
}

func (g *game) ended() bool {
    for i := 0; i < size * size; i++ {
        if g.cells[i] == nil return false
    }

    for i := 0; i < size; i++ {
        for j := 1; j < size; j++ {
            c1 := g.cells[index(i, j)]
            c2 := g.cells[index(i, j - 1)]
            if c1.value == c2.value return false
        }
    }

    for i := 0; i < size; i++ {
        for j := 1; j < size; j++ {
            c1 := g.cells[index(j, i)]
            c2 := g.cells[index(j - 1, i)]
            if c1.value == c2.value return false
        }
    }

    return true // no move
}

func (g *game) run() {
    g.spawn()
    g.spawn()
    g.render(0)
    k := gap()
    g.render(1)

    var s events.Selector
    for {
        if g.ended() {
            g.lost = true
            g.render(1)
            return
        }

        if k == 0 {
            ev := s.Select(nil, nil)
            if ev != events.KeyDown continue
            k = s.LastKeyCode()
        }

        if g.move(k) {
            g.double()
            ended := !g.spawn()
            g.render(0)
            k = gap()
            g.render(1)
            g.freeBg()
            if ended return
        } else {
            // cannot move, consume it
            k = 0
        }
    }
}
