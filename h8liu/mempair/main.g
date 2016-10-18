var theGame game

func main() {
    fmt.PrintStr("Mem pair\n")

    g := &theGame
    g.init()

    for {
        now := etime()
        g.forward(&now)
        g.draw()
        g.pollClick()
    }
}
