var theGame game

func main() {
    fmt.PrintStr("Mem pair\n")

    g := &theGame
    g.init()

    for {
        g.draw()
        g.waitClick()
    }
}