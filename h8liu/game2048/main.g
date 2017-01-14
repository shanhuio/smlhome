var theGame game

func main() {
    rand.SysSeed()
    initFaces()

    g := &theGame
    g.init()
    g.run()
}
