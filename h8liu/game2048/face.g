var classes [15]*canvas.BoxClass

func addClass(i int, text string, fg, bg uint32, fontSize uint8) {
    c := canvas.Get()
    cls := c.AllocBoxClass()

    cls.Text = text
    cls.Foreground = fg
    cls.Background = bg
    cls.FontSize = fontSize
    cls.Width = 80
    cls.Height = 80
    cls.BorderRadius = 3
    cls.TransitionMs = 120

    canvas.UpdateBoxClass(cls)
}

func faceClassID(v uint8) uint8 {
    if int(v) < len(classes) {
        return classes[v].ID()
    }
    return classes[len(classes) - 1].ID()
}

func initFaces() {
    addClass(0, "x", 0x666666, 0xffffff, 40)
    addClass(1, "2", 0x666666, 0xeee4da, 40)
    addClass(2, "4", 0x666666, 0xede0c8, 40)
    addClass(3, "8", 0xf9f6f2, 0xf2b179, 40)
    addClass(4, "16", 0xf9f6f2, 0xf59563, 36)
    addClass(5, "32", 0xf9f6f2, 0xf67c5f, 36)
    addClass(6, "64", 0xf9f6f2, 0xf65e3b, 36)
    addClass(7, "128", 0xf9f6f2, 0xedcf72, 32)
    addClass(8, "256", 0xf9f6f2, 0xedcc61, 32)
    addClass(9, "512", 0xf9f6f2, 0xedc850, 32)
    addClass(10, "1024", 0xf9f6f2, 0xedc53f, 28)
    addClass(11, "2048", 0xf9f6f2, 0xedc22e, 28)
    addClass(12, "4096", 0xf9f6f2, 0x3c3a32, 28)
    addClass(13, "8192", 0xf9f6f2, 0x3c3a32, 28)
    addClass(14, "HUGE", 0xf9f6f2, 0x3c3a32, 28)
}
