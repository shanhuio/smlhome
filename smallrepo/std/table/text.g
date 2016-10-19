struct text {
    pos byte
    w bytes.Buffer
    buf [64]byte
    dirty bool
}

func (t *text) init(p byte) {
    t.pos = p
}

func (t *text) Get() *bytes.Buffer {
    t.w.Init(t.buf[:])
    t.dirty = true
    return &t.w
}

func (t *text) render() {
    if !t.dirty return
    SetTextBytes(t.pos, t.w.Bytes())
    t.dirty = false
}
