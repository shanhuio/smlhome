struct pic {
    prop PicProp
    dirty bool
}

func (p *pic) update(prop *PicProp) {
    if p.prop.equals(prop) return
    p.prop = *prop
    p.dirty = true
}

func (p *pic) render() {
    if !p.dirty return

    p.dirty = false
    if !p.prop.Visible {
        act(picHide, 0)
        return
    }

    act(picShow, 0)
    actNums(picPosition, p.prop.Left, p.prop.Top)
}
