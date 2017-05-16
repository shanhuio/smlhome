var theCanvas canvas

func init() {
    theCanvas.init()
}

func AllocBox() *Box {
    return theCanvas.allocBox()
}

func FreeBox(b *Box) {
    theCanvas.freeBox(b)
}

func AllocBoxClass() *BoxClass {
    return theCanvas.allocBoxClass()
}

func FreeBoxClass(cls *BoxClass) {
    theCanvas.freeBoxClass(cls)
}

func Render(boxes *BoxArray) {
    theCanvas.render(boxes)
}

func UpdateBoxClass(cls *BoxClass) {
    var enc coder.Encoder
    p := prepare()
    p.PayloadCoder(&enc)
    enc.U8(boxClassUpdate)
    cls.encode(&enc)
    call(p, enc.Len())
}
