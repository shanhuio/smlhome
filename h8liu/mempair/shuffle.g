func shuffle(cards []*card, seed uint) {
    var r Rand
    r.init(seed)

    n := len(cards)
    for i := 0; i < n - 1; i++ {
        step := int(r.Uint() % uint(n - i))
        if step == 0 continue
        t := i + step
        cards[t], cards[i] = cards[i], cards[t]
    }
}
