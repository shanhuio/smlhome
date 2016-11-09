const textBufLen = 64

struct text {
    pos byte
    w bytes.Buffer

    s string
    dirty bool
}

func (t *text) init(p byte) {
    t.pos = p
}

func (t *text) update(s string) {
    if strings.Equals(t.s, s) return
    t.s = s
    t.dirty = true
}

func (t *text) render() {
    if !t.dirty return

    actString(labelText, t.pos, t.s)
    t.dirty = false
}
