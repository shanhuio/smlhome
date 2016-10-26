func setup(c *config, cards []*card) {
    base := c.getFace()
    n := len(cards)
    for i := 0; i < n; i++ {
        cards[i].face = base + char(i / 2)
    }

    if c.timeBonusCards && n >= 6 {
        start := n - 6
        for i := 0; i < 6; i++ {
            cards[start + i].face = 'X' + char(i / 2)
        }
    } else if c.findSpecial && n >= 2 {
        cards[n - 2].face = '*'
        cards[n - 1].face = '*'
    }

    if !c.noShuffle {
        shuffle(cards, c.getSeed())
    }
}
