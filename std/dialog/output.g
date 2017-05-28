const (
    cmdSay = 0
    cmdChoice = 1
    cmdWaitChoice = 2
)

func call(p *vpc.Packet, n int) {
    var h vpc.PacketHeader
    h.DestPort = vpc.PortDialog
    p.SetHeader(&h, n)
    vpc.Send(p, n)
}

// Say sends a message to the client
func Say(msg string) {
    var enc coder.Encoder
    p := vpc.PreparePacket()
    p.PayloadCoder(&enc)
    enc.U8(cmdSay)
    enc.I32(len(msg))
    enc.Str(msg)
    call(p, enc.Len())
}

// Choose asks for a choice among several options. Returns -1 when timeout.
func Choose(choices []string, sec int) int {
    var enc coder.Encoder
    p := vpc.PreparePacket()

    n := len(choices)
    for i := 0; i < n; i++ {
        p.PayloadCoder(&enc)
        msg := choices[i]
        enc.U8(cmdChoice)
        enc.U8(uint8(i))
        enc.I32(len(msg))
        enc.Str(msg)
        call(p, enc.Len())
    }

    p.PayloadCoder(&enc)
    enc.U8(cmdWaitChoice)
    call(p, enc.Len())

    // cook the deadline
    var timer time.Timer
    ptimer := &timer

    if sec > 0 {
        var dur long.Long
        dur.Iset(sec)
        dur.Umul1e9()

        now := time.Now()
        timer.Set(&now, &dur)
    } else {
        ptimer = nil
    }

    var s events.Selector
    for {
        what := s.Select(nil, ptimer)
        if what == events.Timer return -1
        if what == events.Choice return s.LastChoice()
    }
}

// AskChoice asks for a choice among several options.
func AskChoice(q string, choices []string, sec int) int {
    Say(q)
    return Choose(choices, sec)
}
