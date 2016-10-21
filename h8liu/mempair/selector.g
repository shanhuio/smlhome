struct selector {
    click int
    clickValid bool
}

const (
    eventNothing = 0
    eventClick = 1
    eventTimer = 2
    eventTicker = 3
)

var msgBuf [16]byte

func (s *selector) LastClick() (int, bool) {
    return s.click, s.clickValid
}

func (s *selector) pollClick(timeout *time.Timeout) bool {
    now := timeNow()
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

func (s *selector) poll(ticker *time.Ticker, timer *time.Timer) int {
    // forward all the timers first
    now := timeNow()
    if timer != nil {
        timer.Forward(&now)
    }
    if ticker != nil {
        ticker.Forward(&now)
    }

    if timer != nil && timer.Poll() return eventTimer
    if ticker != nil && ticker.Poll() return eventTicker
    return eventNothing
}

func (s *selector) Select(ticker *time.Ticker, timer *time.Timer) int {
    ret := s.poll(ticker, timer)
    if ret != eventNothing return ret

    var timeout time.Timeout
    if timer != nil {
        timer.SetTimeout(&timeout)
    }
    if ticker != nil {
        ticker.SetTimeout(&timeout)
    }

    if s.pollClick(&timeout) return eventClick
    return s.poll(ticker, timer)
}
