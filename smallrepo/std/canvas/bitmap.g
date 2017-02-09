struct bitmap {
    mask [npool / 32]uint32
}

func (m *bitmap) clearAll() {
    for i := 0; i < npool / 32; i++ {
        m.mask[i] = 0
    }
}

func (m *bitmap) get(i uint8) bool {
    return ((m.mask[i / 32] >> (i % 32)) & 0x1) == 0x1
}

func (m *bitmap) set(i uint8) {
    m.mask[i / 32] |= uint32(0x1) << (i % 32)
}

func (m *bitmap) clear(i uint8) {
    m.mask[i / 32] &= ^(uint32(0x1) << (i % 32))
}

func (m *bitmap) dat() []uint32 {
    return m.mask[:]
}

func (m *bitmap) marshal(enc *coder.Encoder) {
    for i := 0; i < npool / 32; i++ {
        enc.U32(m.mask[i])
    }
}
