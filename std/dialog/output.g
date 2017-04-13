var msgBuf [1300]byte

func call(buf []byte) {
    _, err := vpc.Call(vpc.Dialog, buf, nil)
    if err != 0 {
        printInt(err)
        panic()
    }
}

const (
    cmdSay = 0
    cmdChoice = 1
    cmdChoose = 2
)

// Say sends a message to the client
func Say(msg string) {
    var enc coder.Encoder
    enc.Init(msgBuf[:])
    enc.U8(cmdSay)
    enc.I32(len(msg))
    enc.Str(msg)

    call(enc.Bytes())
}

// Choose asks for a choice among several options. Returns -1 when timeout.
func Choose(choices []string, sec int) int {
    var enc coder.Encoder
    n := len(choices)
    for i := 0; i < n; i++ {
        msg := choices[i]
        enc.Init(msgBuf[:])
        enc.U8(cmdChoice)
        enc.U8(uint8(i))
        enc.I32(len(msg))
        enc.Str(msg)

        call(enc.Bytes())
    }

    // cook the deadline
    var timer time.Timer
    ptimer := &timer

    if sec > 0 {
        var dur long.Long
        dur.Iset(sec)
        dur.Imul(1e9)

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
