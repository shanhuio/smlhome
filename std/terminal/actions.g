const screenPage = 4096 * 5

func call(p *vpc.Packet, n int) {
    var h vpc.PacketHeader
    h.DestPort = vpc.PortTerminal
    p.SetHeader(&h, n)
    vpc.Send(p, n)
}

func PrintChar(ch char) {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)

    enc.U8(0)
    enc.U8(byte(ch))

    call(p, enc.Len())
}

func Resize(nline, ncol int) {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)

    enc.U8(1)
    enc.U8(byte(nline))
    enc.U8(byte(ncol))

    call(p, enc.Len())
}

func Clear() {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)
    enc.U8(1)
    call(p, enc.Len())
}

func MoveTo(line, col int) {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)

    enc.U8(2)
    enc.U8(byte(line))
    enc.U8(byte(col))

    call(p, enc.Len())
}

func PrintStr(s string) {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)

    enc.U8(0)
    enc.Str(s)

    call(p, enc.Len())
}

func PrintAt(line, col int, ch char) {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)

    enc.U8(2)
    enc.U8(byte(line))
    enc.U8(byte(col))
    enc.U8(byte(ch))

    call(p, enc.Len())
}

// PrintStrAt prints a string at a particular position on the screen.
func PrintStrAt(line, col int, s string) {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)

    enc.U8(2)
    enc.U8(byte(line))
    enc.U8(byte(col))
    enc.Str(s)

    call(p, enc.Len())
}

func PrintInt(i int) {
    var buf [11]byte
    var w bytes.Buffer
    w.Init(buf[:])
    fmt.FprintInt(&w, i)

    PrintStr(w.String())
}
