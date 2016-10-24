struct config {
    noShuffle bool
    face char
    timeLimit int
    failLimit int
    randSeed uint
    timeBonusCards bool
    findSpecial bool

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
