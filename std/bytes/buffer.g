// Buffer is a byte buffer for reading and writing bytes.
struct Buffer {
    // buf is the byte array that is used
    buf []byte

    // n is the current used size
    n int
}

// Init initializes a Buffer with a byte array, set the size to 0.
func (b *Buffer) Init(buf []byte) {
    b.buf = buf
    b.n = 0
}

// Reset clears a Buffer, and sets the size to 0.
func (b *Buffer) Reset() {
    b.n = 0
}

// Len returns the length of a Buffer.
func (b *Buffer) Len() int {
    return b.n
}

// UnreadByte removes the last byte of the buffer.
// It returns false if the Buffer is already empty.
func (b *Buffer) UnreadByte() bool {
    if b.n == 0 return false
    b.n--
    return true
}

// Bytes returns the buffer as a byte slice.
func (b *Buffer) Bytes() []byte {
    return b.buf[:b.n]
}

// String returns the buffer as a String.
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

// WriteByte writes a byte to a Buffer. It returns false if the buffer
// runs out of space.
func (b *Buffer) WriteByte(byt byte) bool {
    // run out of buffer
    if b.n >= len(b.buf) return false
    b.buf[b.n] = byt
    b.n++
    return true
}

// WriteChar writes a char to a Buffer. It return false if the buffer runs
// out of space.
func (b *Buffer) WriteChar(c char) bool {
    return b.WriteByte(byte(c))
}

// WriteString writes a string to a Buffer. It returns the number of chars
// written, and returns false if the buffer runs out of space.
func (b *Buffer) WriteString(s string) (int, bool) {
    n := len(s)
    for i := 0; i < n; i++ {
        // string is condiered as a []char in G language, similar to C
        err := b.WriteChar(s[i])
        if err != true return i, err
    }
    return n, true
}

// Write writes a byte slice to a Buffer. It returns the number of bytes
// written, and returns false if the buffer runs out of space.
func (b *Buffer) Write(bs []byte) (int, bool) {
    for i := 0; i < len(bs); i++ {
        err := b.WriteByte(bs[i])
        if err != true return i, err
    }
    return len(bs), true
}
