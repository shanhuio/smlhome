struct PosPool {
    size int
    cards [24]int
}

func (p *PosPool) IsEmpty() bool {
    return p.size == 0
}

func (p *PosPool) Append(pos int) {
    p.cards[p.size] = pos
    p.size++
}

func (p *PosPool) PopRand() int {
    if (p.size == 0) {
        fmt.PrintStr("Pop from empty card pool.\n")
        panic()
    }

    pick := rand.IntN(p.size)
    ret := p.cards[pick]
    p.cards[pick] = p.cards[p.size - 1]
    p.size--

    return ret
}
