const (
    Nothing = 0
    Click = 1
    Timer = 2
    Ticker = 3
)

struct Selector {
    clickWhat int
    clickPos int
}

var msgBuf [16]byte

func (s *Selector) LastClick() (int, int) {
    return s.clickWhat, s.clickPos
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
        what, pos := table.HandleClick(msg) // parse the message
        s.clickWhat = int(what)
        s.clickPos = int(pos)
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
