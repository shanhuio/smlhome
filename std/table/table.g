struct table {
    cards [Ncard]card
    dirtyCards dirtyMap

    texts [Ntext]text
    buttons [Nbutton]button

    divs [Ndiv]div
    dirtyDivs dirtyMap
}

func (t *table) init() {
    n := len(t.cards)
    t.dirtyCards.init(n)
    for i := 0; i < n; i++ {
        t.cards[i].init(byte(i), &t.dirtyCards)
    }

    n = len(t.texts)
    for i := 0; i < n; i++ {
        t.texts[i].init(byte(i))
    }

    n = len(t.buttons)
    for i := 0; i < n; i++ {
        t.buttons[i].init(byte(i))
    }

    n = len(t.divs)
    t.dirtyDivs.init(n)
    for i := 0; i < n; i++ {
        t.divs[i].init(byte(i), &t.dirtyDivs)
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

    n = len(p.Divs)
    for i := 0; i < n; i++ {
        d := p.Divs[i]
        k := d.Key
        t.divs[k].update(d)
    }
}

func (t *table) render() {
    i := 0
    for {
        pos, ok := t.dirtyCards.iter(&i)
        if !ok break
        t.cards[pos].render()
    }
    t.dirtyCards.clear()

    n := len(t.texts)
    for i := 0; i < n; i++ {
        t.texts[i].render()
    }

    n = len(t.buttons)
    for i := 0; i < n; i++ {
        t.buttons[i].render()
    }

    // update divs
    var enc coder.Encoder
    enc.Init(msgBuf[:])
    enc.U8(divUpdate)

    i = 0
    for {
        index, ok := t.dirtyDivs.iter(&i)
        if !ok break

        p := prepare()
        var enc coder.Encoder
        p.PayloadCoder(&enc)
        enc.U8(divUpdate)
        t.divs[index].encode(&enc)
        call(p, enc.Len())
    }
    t.dirtyDivs.clear()

    actCommit()
}
