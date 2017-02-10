const poolSize = size * size + 3

struct piecePool {
    pieces [poolSize]piece
    pool [poolSize]*piece
    n int
}

func (p *piecePool) init() {
    c := canvas.Get()

    for i := 0; i < poolSize; i++ {
        t := &p.pieces[i]
        t.init(c.AllocBox())
        p.pool[poolSize - 1 - i] = t
    }
    p.n = poolSize
}

func (p *piecePool) alloc(row, col, v uint8) *piece {
    if p.n == 0 {
        panic()
    }
    p.n--
    ret := p.pool[p.n]

    ret.valid = true
    ret.row = row
    ret.col = col
    ret.value = v
    ret.toDouble = false
    ret.newBorn = true
    return ret
}

func (p *piecePool) free(ret *piece) {
    ret.valid = false
    if p.n == poolSize {
        panic()
    }
    p.pool[p.n] = ret
    p.n++
}
