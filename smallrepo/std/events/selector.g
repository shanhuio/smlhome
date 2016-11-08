const (
    Nothing = 0
    Click = 1
    Timer = 2
    Ticker = 3
)

struct Selector {
    click int
    clickValid bool
}

var msgBuf [16]byte

func (s *Selector) LastClick() (int, bool) {
    return s.click, s.clickValid
}

func (s *Selector) pollClick(timeout *time.Timeout) bool {
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
        p, ok := table.HandleClick(msg) // parse the message
        if !ok {
            fmt.PrintStr("invalid table click message\n")
            panic()
        }
        s.click = int(p)
        s.clickValid = p != 255
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

    if s.pollClick(&timeout) return Click
    return s.poll(ticker, timer)
}
