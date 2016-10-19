var theGame game

func main() {
    fmt.PrintStr("Mem pair\n")

    g := &theGame
    g.init()

    for {
        g.render()
        g.pollClick()

        now := timeNow()
        g.forward(&now)
    }
}
