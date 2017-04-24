const (
    Nothing = 0
    Timer = 1
    Ticker = 2
    Click = 3
    KeyDown = 4
    Choice = 5
)

struct Selector {
    lastInput int
    clickWhat int
    clickPos int
    keyCodeValid bool
    keyCode uint8
    choice int
}

var msgBuf [16]byte

func (s *Selector) LastClick() (int, int) {
    return s.clickWhat, s.clickPos
}

func (s *Selector) LastKeyCode() uint8 {
    return s.keyCode
}

func (s *Selector) LastChoice() int {
    return s.choice
}

func handleTableClick(buf []byte) (uint8, uint8) {
    if len(buf) < 2 return 0, 0
    return buf[0], buf[1]
}

func (s *Selector) pollInput(timeout *time.Timeout) bool {
    now := time.Now()
    wait := timeout.Get(&now)
    service, n, err := vpc.Poll(wait, msgBuf[:])
    if err == vpc.ErrTimeout return false
    if err != 0 {
        printInt(err)
        panic()
    }

    msg := msgBuf[:n]
    if service == vpc.Table {
        what, pos := handleTableClick(msg) // parse the message
        s.clickWhat = int(what)
        s.clickPos = int(pos)
        s.lastInput = Click
        return true
    } else if service == vpc.Keyboard {
        s.keyCode = msg[1]
        s.lastInput = KeyDown
        return true
    }

    fmt.PrintStr("unknown service input\n")
    return false
}

func (s *Selector) poll(ticker *time.Ticker, timer *time.Timer) int {
    // forward all the timers first
    now := time.Now()
    if timer != nil {
        timer.Forward(&now)
    }
    if ticker != nil {
        ticker.Forward(&now)
    }

    if timer != nil && timer.Poll() return Timer
    if ticker != nil && ticker.Poll() return Ticker
    return Nothing
}

func (s *Selector) Select(ticker *time.Ticker, timer *time.Timer) int {
    ret := s.poll(ticker, timer)
    if ret != Nothing return ret

    var timeout time.Timeout
    if timer != nil {
        timer.SetTimeout(&timeout)
    }
    if ticker != nil {
        ticker.SetTimeout(&timeout)
    }

    if s.pollInput(&timeout) return s.lastInput
    return s.poll(ticker, timer)
}
