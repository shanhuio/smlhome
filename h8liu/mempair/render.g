struct render {
    buf1 [64]byte
    buf2 [64]byte
    w1 bytes.Buffer
    w2 bytes.Buffer
}

struct renderProp {
    cards []*card
    message string
    failedTries int
    nsecond int
}

func (r *render) init() {
    r.w1.Init(r.buf1[:])
    r.w2.Init(r.buf2[:])
}

func (r *render) render(p *renderProp) {
    r.w1.Reset()
    r.writeStats(&r.w1, p.failedTries)

    r.w2.Reset()
    r.writeTime(&r.w2, p.nsecond)

    var tp table.Prop
    tp.Texts[0] = p.message
    tp.Texts[1] = r.w1.String()
    tp.Texts[3] = r.w2.String()

    ncard := len(p.cards)
    for i := 0; i < ncard; i++ {
        c := p.cards[i]
        if c == nil continue
        pc := &tp.Cards[i]
        pc.Visible = true
        pc.Face = c.face
        pc.FaceUp = c.faceUp
    }

    table.Render(&tp)
}

func (r *render) writeStats(w *bytes.Buffer, failedTries int) {
    w.WriteString("failed tries: ")
    fmt.FprintInt(w, failedTries)
}

func (r *render) writeTime(w *bytes.Buffer, t int) {
    fmt.FprintInt(w, t)
    w.WriteString(" sec")
}
