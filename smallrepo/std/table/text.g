const textBufLen = 64

struct text {
    pos byte
    w bytes.Buffer

    current []byte

    bufLeft [textBufLen]byte
    bufRight [textBufLen]byte
    rightActive bool

    dirty bool
}

func (t *text) init(p byte) {
    t.pos = p
}

func (t *text) inactiveBuf() []byte {
    if t.rightActive return t.bufLeft[:]
    return t.bufRight[:]
}

func (t *text) clear() {
    t.get()
}

func (t *text) get() *bytes.Buffer {
    t.w.Init(t.inactiveBuf())
    t.dirty = true
    return &t.w
}

func (t *text) render() {
    if !t.dirty return

    bs := t.w.Bytes()
    if !bytes.Equal(bs, t.current) {
        SetTextBytes(t.pos, t.w.Bytes())
        t.current = bs
        t.rightActive = !t.rightActive
    }

    t.dirty = false
}
