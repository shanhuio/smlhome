struct config {
    noShuffle bool
    face char
    timeLimit int
    failLimit int
    randSeed uint

    setupFunc func(cards []*card, base char)
}

func (c *config) getFace() char {
    if c.face == char(0) return 'A'
    return c.face
}

func (c *config) getSeed() uint {
    if c.randSeed == 0 return misc.Rand()
    return c.randSeed
}

func (c *config) setup(cards []*card) {
    base := c.getFace()
    n := len(cards)
    for i := 0; i < n; i++ {
        cards[i].face = base + char(i / 2)
    }

    if !c.noShuffle {
        shuffle(cards, c.getSeed())
    }
}
