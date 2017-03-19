const (
    Ncard = 24
    Ntext = 8
    Nbutton = 2
    Ndiv = 256
)

struct CardProp {
    Visible bool
    Face char
    FaceUp bool
}

func (p *CardProp) ShowFace(face char) {
    p.Visible = true
    p.Face = face
    p.FaceUp = true
}

func (p *CardProp) ShowBack() {
    p.Visible = true
    p.FaceUp = false
}

func (p *CardProp) equals(other *CardProp) bool {
    if p.Visible != other.Visible return false
    if !p.Visible return true
    return p.FaceUp == other.FaceUp && p.Face == other.Face
}

func (p *CardProp) action() byte {
    if p.Visible {
        if p.FaceUp return cardShowFront
        return cardShowBack
    }

    if p.FaceUp return cardHideFront
    return cardHideBack
}

struct ButtonProp {
    Visible bool
    Text string
}

func (p *ButtonProp) equals(other *ButtonProp) bool {
    if p.Visible != other.Visible return false
    if !p.Visible return true
    return strings.Equals(p.Text, other.Text)
}

struct Div {
    Key uint8
    Visible bool
    ZIndex uint8
    Transition uint32 // in ms
    Left, Top int
    Width, Height int
    Color uint32
    BackgroundColor uint32
    FontSize uint8
    BorderRadius uint8
    Text string
}

func hiLo16(a, b int) uint32 {
    return ((uint32(a) & 0xffff) << 16) | (uint32(b) & 0xffff)
}

func (d *Div) encode(enc *coder.Encoder) {
    enc.U8(d.Key)
    enc.Bool(d.Visible)
    if !d.Visible return

    enc.U8(d.ZIndex)
    enc.U32(d.Transition)

    enc.U32(hiLo16(d.Left, d.Top))
    enc.U32(hiLo16(d.Width, d.Height))
    enc.U32(d.Color)
    enc.U32(d.BackgroundColor)
    enc.U8(d.FontSize)
    enc.U8(d.BorderRadius)
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

struct Prop {
    Cards [Ncard]CardProp
    Buttons [Nbutton]ButtonProp
    Texts [Ntext]string

    Divs []*Div
}
