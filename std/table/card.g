struct card {
    pos byte

    prop CardProp

    dirty bool
    m *dirtyMap
}

func (c *card) init(p byte, m *dirtyMap) {
    c.pos = p
    c.m = m
}

func (c *card) touch() {
    if !c.dirty {
        c.m.touch(c.pos)
    }
    c.dirty = true
}

func (c *card) update(p *CardProp) {
    if c.prop.equals(p) return
    c.prop = *p
    c.touch()
}

func (c *card) render() {
    if !c.dirty return

    p := &c.prop
    actChar(cardFace, c.pos, p.Face)
    act(p.action(), c.pos)
    c.dirty = false
}
