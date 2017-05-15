func U32(bs []byte) uint32 {
    ret := uint32(bs[0])
    ret |= uint32(bs[1]) << 8
    ret |= uint32(bs[2]) << 16
    ret |= uint32(bs[3]) << 24
    return ret
}

func U32B(bs []byte) uint32 {
    ret := uint32(bs[0]) << 24
    ret |= uint32(bs[1]) << 16
    ret |= uint32(bs[2]) << 8
    ret |= uint32(bs[3])
    return ret
}

func U16(bs []byte) uint32 {
    ret := uint32(bs[0])
    ret |= uint32(bs[1]) << 8
    return ret
}

func U16B(bs []byte) uint32 {
    ret := uint32(bs[0]) << 8
    ret |= uint32(bs[1])
    return ret
}

func I32(bs []byte) int32 {
    return int32(U32(bs))
}
