const nboxClass = npool

struct BoxClass {
    id uint8

    FontSize uint8
    BorderRadius uint8

    Width uint32
    Height uint32

    Foreground uint32
    Background uint32
    TransitionMs uint32

    Text string
}

func (c *BoxClass) init() {
    c.FontSize = 12
    c.BorderRadius = 0
    c.Width = 100
    c.Height = 30
    c.Foreground = 0
    c.Background = 0xffffff
    c.TransitionMs = 0
    c.Text = ""
}

func (c *BoxClass) ID() uint8 {
    return c.id
}

func (c *BoxClass) encode(enc *coder.Encoder) {
    enc.U8(c.id)
    enc.U8(c.FontSize)
    enc.U8(c.BorderRadius)
    enc.U32(hiLo16u(c.Width, c.Height))
    enc.U32(c.Foreground)
    enc.U32(c.Background)
    enc.U32(c.TransitionMs)
    enc.U8(uint8(len(c.Text)))
    enc.Str(c.Text)
}
