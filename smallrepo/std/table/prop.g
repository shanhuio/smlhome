const (
    Ncard = 24
    Ntext = 8
    Nbutton = 2
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

struct PicProp {
    Visible bool
    Left int
    Top int
}

func (p *PicProp) equals(other *PicProp) bool {
    if p.Visible != other.Visible return false
    if !p.Visible return true
    return p.Left == other.Left && p.Top == other.Top
}

struct Prop {
    Cards [Ncard]CardProp
    Buttons [Nbutton]ButtonProp
    Texts [Ntext]string
    Pic PicProp

    Divs []*Div
}
