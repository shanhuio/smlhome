struct table {
    cards [Ncard]card
    texts [Ntext]text
    buttons [Nbutton]button
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
}
