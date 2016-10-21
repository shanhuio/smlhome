struct dirtyMap {
    dirty [Ncard]bool
    blocks [Ncard]byte
    n int
}

func (m *dirtyMap) touch(p byte) {
    if m.dirty[p] return
    m.dirty[p] = true
    m.blocks[m.n] = p
    m.n++
}

func (m *dirtyMap) clear() {
    for i := 0; i < m.n; i++ {
        m.dirty[m.blocks[i]] = false
    }
    m.n = 0
}

func (m *dirtyMap) iter(i *int) (byte, bool) {
    if *i == m.n return 0, false
    ret := m.blocks[*i]
    *i++
    return ret, true
}
