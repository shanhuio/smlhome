struct config {
    setupFunc func(cards []*card)
}

func defaultSetup(cards []*card) {
    n := len(cards)
    for i := 0; i < n; i++ {
        cards[i].face = 'A' + char(i / 2)
    }
    shuffle(cards)
}

func setup(c *config, cards []*card) {
    if c == nil || c.setupFunc == nil {
        defaultSetup(cards)
        return
    }

    c.setupFunc(cards)
}
