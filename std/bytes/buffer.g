struct Buffer {
    // buf is the byte array used for the Buffer,
    // n is the current occupied size of the Buffer.
    buf []byte
    n int
}

// func Init intiates a Buffer with a byte array, set the size to 0.
func (b *Buffer) Init(buf []byte) {
    b.buf = buf
    b.n = 0
}

// func Reset clears a Buffer, set the size to 0.
func (b *Buffer) Reset() {
    b.n = 0
}

// func Len() returns the length of a Buffer.
func (b *Buffer) Len() int {
    return b.n
}

// func UnreadByte remove the last byte of the Buffer,
// return false if the Buffer is empty.
func (b *Buffer) UnreadByte() bool {
    if b.n == 0 return false
    b.n--
    return true
}

// func Bytes returns the Buffer as a byte slice.
func (b *Buffer) Bytes() []byte {
    return b.buf[:b.n]
}

// func String returns the Buffer as a String.
func (b *Buffer) String() string {
    bs := b.Bytes()
    if len(bs) == 0 {
        return ""
    }
    // In G language, the String is considered as a []char.
    // TODO(h8liu): this is more like a hack
    // maybe we should always use []byte as string?
    return make([]char, len(bs), (*char)(&bs[0]))
}

// func WriteByte write a byte to a Buffer, return false if no space.
func (b *Buffer) WriteByte(byt byte) bool {
    // run out of buffer
    if b.n >= len(b.buf) return false
    b.buf[b.n] = byt
    b.n++
    return true
}

// func WriteByte write a char to a Buffer, return false if no space.
func (b *Buffer) WriteChar(c char) bool {
    return b.WriteByte(byte(c))
}

// func WriteByte write a string to a Buffer, return false if no space.
func (b *Buffer) WriteString(s string) (int, bool) {
    n := len(s)
    for i := 0; i < n; i++ {
        // string is condiered as a []char in G language, similar to C
        err := b.WriteChar(s[i])
        if err != true return i, err
    }
    return n, true
}

// func Write write a []byte to a Buffer, return false if no space.
func (b *Buffer) Write(bs []byte) (int, bool) {
    for i := 0; i < len(bs); i++ {
        err := b.WriteByte(bs[i])
        if err != true return i, err
    }
    return len(bs), true
}
