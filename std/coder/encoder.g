struct Encoder {
    buf bytes.Buffer
}

func (c *Encoder) Init(bs []byte) {
    c.buf.Init(bs)
}

func (c *Encoder) Pad(n int) {
    for i := 0; i < n; i++ {
        c.buf.WriteByte(0)
    }
}

func (c *Encoder) U32(v uint32) {
    var buf [4]byte
    binary.PutU32(buf[:], v)
    c.buf.Write(buf[:])
}

func (c *Encoder) U32B(v uint32) {
    var buf [4]byte
    binary.PutU32B(buf[:], v)
    c.buf.Write(buf[:])
}

func (c *Encoder) U16(v uint32) {
    var buf [2]byte
    binary.PutU16(buf[:], v)
    c.buf.Write(buf[:])
}

func (c *Encoder) U16B(v uint32) {
    var buf [2]byte
    binary.PutU16B(buf[:], v)
    c.buf.Write(buf[:])
}

func (c *Encoder) I32(v int32) {
    c.U32(uint32(v))
}

func (c *Encoder) U8(u uint8) {
    c.buf.WriteByte(u)
}

func (c *Encoder) Bool(b bool) {
    if b {
        c.buf.WriteByte(1)
    } else {
        c.buf.WriteByte(0)
    }
}

func (c *Encoder) Str(s string) {
    c.buf.WriteString(s)
}

func (c *Encoder) Write(bs []byte) {
    c.buf.Write(bs)
}

func (c *Encoder) Bytes() []byte {
    return c.buf.Bytes()
}

func (c *Encoder) Len() int {
    return c.buf.Len()
}
