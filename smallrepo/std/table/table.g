struct Table {
    cards [ncard]Card
    texts [ntext]text
    m dirtyMap
}

func (t *Table) Card(i int) *Card {
    return &t.cards[i]
}

func (t *Table) Text(i int) *bytes.Buffer {
    return t.texts[i].Get()
}

func (t *Table) Init() {
    for i := 0; i < ncard; i++ {
        t.cards[i].init(byte(i), &t.m)
    }
    for i := 0; i < ntext; i++ {
        t.texts[i].init(byte(i))
    }
}

func (t *Table) Render() {
    i := 0
    for {
        pos, ok := t.m.iter(&i)
        if !ok break
        t.cards[pos].render()
    }

    for i := 0; i < ntext; i++ {
        t.texts[i].render()
    }
}
