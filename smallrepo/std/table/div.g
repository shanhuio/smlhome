struct div {
    dirty bool
    prop Div
}

struct Div {
    Key uint8
    Visible bool
    ZIndex uint8
    Transition uint32 // in ms
    Left, Top uint32
    Width, Height uint32
    Color uint32
    BackgroundColor uint32
    FontSize uint32
    BorderRadius uint32
    Text string
}

func (d *Div) encode(enc *coder.Encoder) {
    enc.U8(d.Key)
    enc.Bool(d.Visible)
    if !d.Visible return

    enc.U8(d.ZIndex)
    enc.U32(d.Transition)
    enc.U32(d.Left)
    enc.U32(d.Top)
    enc.U32(d.Width)
    enc.U32(d.Height)
    enc.U32(d.Color)
    enc.U32(d.BackgroundColor)
    enc.U32(d.FontSize)
    enc.U32(d.BorderRadius)
    enc.U8(uint8(len(d.Text)))
    enc.Str(d.Text)
}

func (d *Div) equals(other *Div) bool {
    if d.Key != other.Key return false
    if d.Visible != other.Visible return false
    if !d.Visible return true

    if d.Left != other.Left return false
    if d.Top != other.Top return false
    if d.Width != other.Width return false
    if d.Height != other.Height return false

    if !strings.Equals(d.Text, other.Text) return false
    if d.ZIndex != other.ZIndex return false

    if d.Transition != other.Transition return false
    if d.Color != other.Color return false
    if d.BackgroundColor != other.BackgroundColor return false
    if d.FontSize != other.FontSize return false
    if d.BorderRadius != other.BorderRadius return false

    return true
}

func (d *div) update(p *Div) {
    if d.prop.equals(p) return
    if p.Visible {
        d.prop = *p
    } else {
        d.prop.Visible = false
    }
    d.dirty = true
}

func (d *div) encode(enc *coder.Encoder) {
    if !d.dirty return
    d.dirty = false
    d.prop.encode(enc)
}
