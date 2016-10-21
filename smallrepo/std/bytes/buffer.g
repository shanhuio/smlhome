struct Buffer {
    buf []byte
    n int
}

func (b *Buffer) Init(buf []byte) {
    b.buf = buf
    b.n = 0
}

func (b *Buffer) Reset() {
    b.n = 0
}

func (b *Buffer) Write(bs []byte) (int, int) {
    for i := 0; i < len(bs); i++ {
        err := b.WriteByte(bs[i])
        if err != 0 return i, err
    }
    return len(bs), 0
}

func (b *Buffer) Bytes() []byte {
    return b.buf[:b.n]
}

func (b *Buffer) String() string {
    bs := b.Bytes()
    // TODO(h8liu): this is more like a hack
    // maybe we should always use []byte as string?
    return make([]char, len(bs), (*char)(&bs[0]))
}

func (b *Buffer) WriteByte(byt byte) int {
    if b.n == len(b.buf) return -1 // run out of buffer
    b.buf[b.n] = byt
    b.n++
    return 0
}

func (b *Buffer) WriteChar(c char) int {
    return b.WriteByte(byte(c))
}

func (b *Buffer) WriteString(s string) (int, int) {
    n := len(s)
    for i := 0; i < n; i++ {
        err := b.WriteChar(s[i])
        if err != 0 return i, err
    }
    return n, 0
}
