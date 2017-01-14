struct bitmap {
    m [4]uint32
}

func (m *bitmap) clear() {
    m.m[0] = 0
    m.m[1] = 0
    m.m[2] = 0
    m.m[3] = 0
}

func (m *bitmap) set(i uint8) {
    m.m[i / 32] |= uint32(0x1) << (i % 32)
}

func (m *bitmap) encode(enc *coder.Encoder) {
    enc.U32(m.m[0])
    enc.U32(m.m[1])
    enc.U32(m.m[2])
    enc.U32(m.m[3])
}
