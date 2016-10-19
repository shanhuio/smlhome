struct Card {
    pos byte
    face char
    visible bool
    frontUp bool
    dirty bool

    m *dirtyMap
}

func (c *Card) init(p byte, m *dirtyMap) {
    c.pos = p
    c.m = m
}

func (c *Card) action() byte {
    if c.visible {
        if c.frontUp return ShowFront
        return ShowBack
    }

    if c.frontUp return HideFront
    return HideBack
}

func (c *Card) touch() {
    if !c.dirty {
        c.m.touch(c.pos)
    }
    c.dirty = true
}

func (c *Card) SetFace(f char) {
    if c.face == f return
    c.face = f
    c.touch()
}

func (c *Card) SetVisible(b bool) {
    if c.visible == b return
    c.visible = b
    c.touch()
}

func (c *Card) SetFrontUp(b bool) {
    if c.frontUp == b return
    c.frontUp = b
    c.touch()
}

func (c *Card) Show(face char, frontUp bool) {
    c.SetVisible(true)
    c.SetFace(face)
    c.SetFrontUp(frontUp)
}

func (c *Card) Hide() {
    c.SetVisible(false)
}

func (c *Card) render() {
    if !c.dirty return

    SetFace(c.pos, c.face)
    Act(c.pos, c.action())
    c.dirty = false
}
