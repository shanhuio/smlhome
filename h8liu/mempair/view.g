struct view {
}

func (v *view) SetMessage(s string) {
    table.SetText(0, s)
}

func (v *view) SetStats(bs []byte) {
    table.SetTextBytes(1, bs)
}

func (v *view) SetTime(t int) {
    var buf [20]byte
    var line bytes.Buffer
    line.Init(buf[:])
    fmt.FprintInt(&line, t)
    line.WriteString(" sec")

    bs := line.Bytes()
    table.SetTextBytes(3, bs)
}

var theView view
