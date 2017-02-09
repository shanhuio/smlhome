const nbox = npool

struct Box {
    id uint8

    ClassID uint8
    Left int32
    Top int32
    Text string
}

// box is the internal shadow box
struct box {
    buf [textBufLen]byte
    w bytes.Buffer

    classID uint8
    left int32
    top int32
    text string

    dirty bool
}

func (b *box) init() {
    b.w.Init(b.buf[:])
}

func (b *box) equals(prop *Box) bool {
    if b.left != prop.Left return false
    if b.top != prop.Top return false
    if b.classID != prop.ClassID return false
    if !strings.Equals(b.text, prop.Text) return false
    return true
}

func (b *box) setText(s string) {
    if len(s) == 0 {
        b.text = ""
    }

    b.w.Reset()
    b.w.WriteString(s)
    b.text = b.w.String()
}

func (b *box) update(prop *Box) bool {
    if b.equals(prop) return b.dirty

    b.setText(prop.Text)
    b.classID = prop.ClassID
    b.left = prop.Left
    b.top = prop.Top
    b.dirty = true
    return b.dirty
}

func (b *box) marshal(id uint8, enc *coder.Encoder) {
    enc.U8(id)
    enc.U8(b.classID)
    enc.U32(hiLo16(b.left, b.top))
    enc.U8(uint8(len(b.text)))
    enc.Str(b.text)
}
