const (
    Ncard = 24
    Ntext = 8
)

struct CardProp {
    Visible bool
    Face char
    FaceUp bool
}

func (p *CardProp) equals(other *CardProp) bool {
    if p.Visible != other.Visible return false
    if !p.Visible return true
    return p.FaceUp == other.FaceUp && p.Face == other.Face
}

func (p *CardProp) action() byte {
    if p.Visible {
        if p.FaceUp return ShowFront
        return ShowBack
    }

    if p.FaceUp return HideFront
    return HideBack
}

struct Prop {
    Cards [Ncard]CardProp
    Texts [Ntext]string
}
