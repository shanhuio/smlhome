const textBufLen = 64

struct text {
    pos byte
    buf [textBufLen]byte
    w bytes.Buffer

    s string
    dirty bool
}

func (t *text) init(p byte) {
    t.pos = p
    t.w.Init(t.buf[:])
}

func (t *text) update(s string) {
    if strings.Equals(t.s, s) return

    t.w.Reset()
    t.w.WriteString(s)
    t.s = t.w.String()
    t.dirty = true
}

func (t *text) render() {
    if !t.dirty return

    actString(labelText, t.pos, t.s)
    t.dirty = false
}
