func hiLo16(a, b int) uint32 {
    return ((uint32(a) & 0xffff) << 16) | (uint32(b) & 0xffff)
}

func hiLo16u(a, b uint32) uint32 {
    return ((a & 0xffff) << 16) | (b & 0xffff)
}
