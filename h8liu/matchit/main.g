var theGame game

func main() {
    rand.SysSeed()

    g := &theGame

    g.init()
    for {
        g.run()
        g.reset()
    }
}
