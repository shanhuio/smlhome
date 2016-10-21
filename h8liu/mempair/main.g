var levels [8]game

func main() {
    fmt.PrintStr("Mem pair\n")

    g := &levels[0]

    for {
        g.run()

        // wait for a click
        var s selector
        s.Select(nil, nil)
    }
}
