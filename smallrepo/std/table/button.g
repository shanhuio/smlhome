struct button {
    pos byte
    prop ButtonProp
    dirty bool
}

func (b *button) init(p byte) {
    b.pos = p
}

func (b *button) touch() {
    b.dirty = true
}

func (b *button) update(p *ButtonProp) {
    if b.prop.equals(p) return
    b.prop = *p
    b.touch()
}

func (b *button) render() {
    if !b.dirty return
    p := &b.prop
    if p.Visible {
        actString(buttonText, b.pos, b.prop.Text)
        act(buttonShow, b.pos)
    } else {
        act(buttonHide, b.pos)
    }
    b.dirty = false
}
