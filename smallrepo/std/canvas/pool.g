struct pool {
    using bitmap
    items [npool]uint8
    nitem int
}

func (p *pool) init() {
    for i := 0; i < npool; i++ {
        p.items[i] = uint8(i)
    }
    p.using.clearAll()
    p.nitem = npool
}

func (p *pool) alloc() (uint8, bool) {
    if p.nitem == 0 return 0, false
    p.nitem--
    ret := p.items[p.nitem]
    if p.using.get(ret) {
        panic()
    }
    p.using.set(ret)
    return ret, true
}

func (p *pool) free(i uint8) bool {
    if !p.using.get(i) return false
    p.using.clear(i)
    p.items[p.nitem] = i
    p.nitem++
    return true
}
