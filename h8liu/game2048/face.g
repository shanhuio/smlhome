struct face {
    text string
    color uint32
    background uint32
    fontSize uint8
}

var pieceFaces [15]face

func setFace(i int, text string, fore, back uint32, size uint8) {
    f := &pieceFaces[i]
    f.text = text
    f.color = fore
    f.background = back
    f.fontSize = size
}

func initFaces() {
    setFace(0, "x", 0x666666, 0xffffff, 40)
    setFace(1, "2", 0x666666, 0xeee4da, 40)
    setFace(2, "4", 0x666666, 0xede0c8, 40)
    setFace(3, "8", 0xf9f6f2, 0xf2b179, 40)
    setFace(4, "16", 0xf9f6f2, 0xf59563, 36)
    setFace(5, "32", 0xf9f6f2, 0xf67c5f, 36)
    setFace(6, "64", 0xf9f6f2, 0xf65e3b, 36)
    setFace(7, "128", 0xf9f6f2, 0xedcf72, 32)
    setFace(8, "256", 0xf9f6f2, 0xedcc61, 32)
    setFace(9, "512", 0xf9f6f2, 0xedc850, 32)
    setFace(10, "1024", 0xf9f6f2, 0xedc53f, 28)
    setFace(11, "2048", 0xf9f6f2, 0xedc22e, 28)
    setFace(12, "4096", 0xf9f6f2, 0x3c3a32, 28)
    setFace(13, "8192", 0xf9f6f2, 0x3c3a32, 28)
    setFace(14, "!!!!", 0xf9f6f2, 0x3c3a32, 28)
}
