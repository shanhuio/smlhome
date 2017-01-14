const maxDirtyMap = 256

struct dirtyMap {
    dirtyBuf [maxDirtyMap]bool
    blocksBuf [maxDirtyMap]byte

    dirty []bool
    blocks []byte
    max int
    n int
}

func (m *dirtyMap) init(max int) {
    m.dirty = m.dirtyBuf[:max]
    m.blocks = m.blocksBuf[:max]
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
