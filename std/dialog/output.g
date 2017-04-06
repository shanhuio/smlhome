var msgBuf [1300]byte

func call(buf []byte) {
    _, err := vpc.Call(vpc.Table, buf, nil)
    if err != 0 {
        printInt(err)
        panic()
    }
}

const (
    cmdSay = 0
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

// AskChoice ask for choosing among several options.
func AskChoice(cs *Choices) int {
    panic()
    return 0
}

// AskInt asks for an integer.
func AskInt() int {
    panic()
    return 0
}

// Ask asks for a message.
func AskString(prompt string) string {
    panic()
    return ""
}
