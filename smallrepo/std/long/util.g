func hiLo(v uint32) (uint32, uint32) {
    return v >> 16, v & 0xffff
}

func bind(hi, lo uint32) uint32 {
    return (hi << 16) | lo
}
