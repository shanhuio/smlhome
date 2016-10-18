struct card {
    face char
    showingFace bool
    hidden bool
}

func shuffle(cards []*card) {
    n := len(cards)
    for i := 0; i < n - 1; i++ {
        step := int(misc.Rand() % uint(n - i))
        if step == 0 continue
        t := i + step
        cards[t], cards[i] = cards[i], cards[t]
    }
}
