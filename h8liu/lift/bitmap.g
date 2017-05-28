struct Bitmap {
    bits uint32
}

func (b *Bitmap) Clear(i int) {
    b.bits &= ^(uint32(0x1) << uint(i))
}

func (b *Bitmap) Set(i int) {
    b.bits |= uint32(0x1) << uint(i)
}

func (b *Bitmap) Get(i int) bool {
    return ((b.bits >> uint(i)) & uint32(0x1)) == uint32(0x1)
}
