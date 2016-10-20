struct render {
    t table.Table
}

struct renderProp {
    cards []*card
    message string
    failedTries int
    nsecond int
}

func (r *render) init() {
    r.t.Init()
}

func (r *render) render(p *renderProp) {
    tab := &r.t

    tab.Text(0).WriteString(p.message)
    r.writeStats(tab.Text(1), p.failedTries)
    r.writeTime(tab.Text(3), p.nsecond)

    ncard := len(p.cards)
    for i := 0; i < ncard; i++ {
        tc := tab.Card(i)
        c := p.cards[i]
        if c == nil {
            tc.Hide()
            continue
        }

        tc.Show(c.face, c.faceUp)
    }

    tab.Render()
}

func (r *render) writeStats(w *bytes.Buffer, failedTries int) {
    w.WriteString("failed tries: ")
    fmt.FprintInt(w, failedTries)
}

func (r *render) writeTime(w *bytes.Buffer, t int) {
    fmt.FprintInt(w, t)
    w.WriteString(" sec")
}
