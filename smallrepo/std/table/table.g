struct table {
    cards [Ncard]card
    texts [Ntext]text
    buttons [Nbutton]button
    maxDiv int
    divs [256]div
    pic pic
    m dirtyMap
}

func (t *table) init() {
    n := len(t.cards)
    for i := 0; i < n; i++ {
        t.cards[i].init(byte(i), &t.m)
    }

    n = len(t.texts)
    for i := 0; i < n; i++ {
        t.texts[i].init(byte(i))
    }

    n = len(t.buttons)
    for i := 0; i < n; i++ {
        t.buttons[i].init(byte(i))
    }
}

func (t *table) update(p *Prop) {
    n := len(t.cards)
    for i := 0; i < n; i++ {
        t.cards[i].update(&p.Cards[i])
    }

    n = len(t.texts)
    for i := 0; i < n; i++ {
        t.texts[i].update(p.Texts[i])
    }

    n = len(t.buttons)
    for i := 0; i < n; i++ {
        t.buttons[i].update(&p.Buttons[i])
    }

    t.pic.update(&p.Pic)

    n = len(p.Divs)
    for i := 0; i < n; i++ {
        d := p.Divs[i]
        k := d.Key
        lim := int(d.Key) + 1
        if t.maxDiv < lim {
            t.maxDiv = lim
        }
        t.divs[k].update(d)
    }
}

func (t *table) render() {
    i := 0
    for {
        pos, ok := t.m.iter(&i)
        if !ok break
        t.cards[pos].render()
    }
    t.m.clear()

    n := len(t.texts)
    for i := 0; i < n; i++ {
        t.texts[i].render()
    }

    n = len(t.buttons)
    for i := 0; i < n; i++ {
        t.buttons[i].render()
    }

    t.pic.render()

    var enc coder.Encoder
    enc.Init(msgBuf[:])
    enc.U8(divUpdate)

    n = t.maxDiv
    for i := 0; i < n; i++ {
        t.divs[i].encode(&enc)
    }

    call(enc.Bytes())
}
