struct bitmap {
    bits uint32
}

func (b *bitmap) clear(i int) {
    b.bits &= ^(uint32(0x1) << uint(i))
}

func (b *bitmap) set(i int) {
    b.bits |= uint32(0x1) << uint(i)
}

func (b *bitmap) get(i int) bool {
    return ((b.bits >> uint(i)) & uint32(0x1)) == uint32(0x1)
}
