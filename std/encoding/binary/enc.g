func PutU32(buf []byte, u uint32) {
    buf[0] = byte(u)
    buf[1] = byte(u >> 8)
    buf[2] = byte(u >> 16)
    buf[3] = byte(u >> 24)
}

func PutI32(buf []byte, i int32) {
    PutU32(buf, uint32(i))
}

func PutU16(buf []byte, u uint32) {
    buf[0] = byte(u)
    buf[1] = byte(u >> 8)
}

func PutU16B(buf []byte, u uint32) {
    buf[0] = byte(u >> 8)
    buf[1] = byte(u)
}

func PutU32B(buf []byte, u uint32) {
    buf[0] = byte(u >> 24)
    buf[1] = byte(u >> 16)
    buf[2] = byte(u >> 8)
    buf[3] = byte(u)
}
