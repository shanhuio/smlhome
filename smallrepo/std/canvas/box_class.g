const nboxClass = npool

struct BoxClass {
    id uint8

    FontSize uint8
    ZIndex uint8
    BorderRadius uint8

    Width uint32
    Height uint32

    Foreground uint32
    Background uint32
    TransitionMs uint32

    Text string
}

func (c *BoxClass) ID() uint8 {
    return c.id
}

func (c *BoxClass) encode(enc *coder.Encoder) {
    enc.U8(c.id)
    enc.U8(c.FontSize)
    enc.U8(c.ZIndex)
    enc.U8(c.BorderRadius)
    enc.U32(hiLo16u(c.Width, c.Height))
    enc.U32(c.Foreground)
    enc.U32(c.Background)
    enc.U32(c.TransitionMs)
    enc.U8(uint8(len(c.Text)))
    enc.Str(c.Text)
}
