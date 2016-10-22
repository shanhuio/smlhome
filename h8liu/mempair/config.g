struct config {
    setupFunc func(cards []*card)
}

func basicFaces(cards []*card) {
    n := len(cards)
    for i := 0; i < n; i++ {
        cards[i].face = 'A' + char(i / 2)
    }
}

func defaultSetup(cards []*card) {
    basicFaces(cards)
    shuffle(cards)
}

func easySetup(cards []*card) {
    basicFaces(cards)
}

func setup(c *config, cards []*card) {
    if c == nil || c.setupFunc == nil {
        defaultSetup(cards)
        return
    }

    c.setupFunc(cards)
}
