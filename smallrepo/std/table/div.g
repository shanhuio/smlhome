struct div {
    dirty bool
    prop Div
    m *dirtyMap
}

func (d *div) init(k uint8, m *dirtyMap) {
    d.dirty = false
    d.prop.Key = k
    d.m = m
}

func (d *div) update(p *Div) {
    if d.prop.equals(p) return
    if p.Visible {
        d.prop = *p
    } else {
        d.prop.Visible = false
    }

    if !d.dirty {
        d.m.touch(d.prop.Key)
    }
    d.dirty = true
}

func (d *div) encode(enc *coder.Encoder) {
    if !d.dirty return
    d.dirty = false
    d.prop.encode(enc)
}
