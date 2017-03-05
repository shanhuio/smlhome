var theGame game

func main() {
    rand.SysSeed()
    initFaces()
    initMsgClass()

    g := &theGame
    g.init()

    g.run()
}
