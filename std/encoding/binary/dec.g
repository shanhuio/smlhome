func U32(bs []byte) uint32 {
    ret := uint32(bs[0])
    ret |= uint32(bs[1]) << 8
    ret |= uint32(bs[2]) << 16
    ret |= uint32(bs[3]) << 24
    return ret
}

func I32(bs []byte) int32 {
    return int32(U32(bs))
}
