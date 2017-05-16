const (
    Nothing = 0
    Timer = 1
    Ticker = 2
    Click = 3
    KeyDown = 4
    Choice = 5
)

const (
    portDialog = 1001
    portTable = 1002
    portKeyboard = 1003
    portTerminal = 1004
)

struct Selector {
    lastInput int
    clickWhat int
    clickPos int
    keyCodeValid bool
    keyCode uint8
    choice int
}

var msgBuf [1500]byte

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

func (s *Selector) handlePacket(p []byte) {
    if len(p) < vpc.PacketHeaderLen return // header missing
    h := p[:vpc.PacketHeaderLen]
    destPort := binary.U16B(h[12:14])
    payload := p[vpc.PacketHeaderLen:]
    switch destPort {
    case portDialog:
        if len(payload) > 0 {
            s.choice = int(payload[0])
            s.lastInput = Choice
        }
    case portTable:
        what, pos := handleTableClick(payload)
        s.clickWhat = int(what)
        s.clickPos = int(pos)
        s.lastInput = Click
    case portKeyboard:
        if len(payload) > 0 {
            s.keyCode = payload[0]
            s.lastInput = KeyDown
        }
    default:
        printUint(destPort)
    }
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
    if service == 0 {
        s.handlePacket(msg)
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
