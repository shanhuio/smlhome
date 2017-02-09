struct Prop {
    Boxes BoxArray
}

struct Canvas {
    boxClasses [nboxClass]BoxClass
    boxes [nbox]Box

    shadowBoxes [nbox]box

    boxPool pool
    boxClassPool pool
}

func (c *Canvas) Init() {
    for i := 0; i < nbox; i++ {
        c.boxes[i].id = uint8(i)
    }
    for i := 0; i < nbox; i++ {
        c.shadowBoxes[i].init()
    }
    for i := 0; i < nboxClass; i++ {
        c.boxClasses[i].id = uint8(i)
    }

    c.boxPool.init()
    c.boxClassPool.init()
}

func (c *Canvas) AllocBox() *Box {
    i, ok := c.boxPool.alloc()
    if !ok return nil
    return &c.boxes[i]
}

func (c *Canvas) FreeBox(b *Box) {
    c.boxPool.free(b.id)
}

func (c *Canvas) AllocBoxClass() *BoxClass {
    i, ok := c.boxClassPool.alloc()
    if !ok return nil
    return &c.boxClasses[i]
}

func (c *Canvas) FreeBoxClass(cls *BoxClass) {
    c.boxClassPool.free(cls.id)
}

func (c *Canvas) Render(boxes *BoxArray) {
    var visible bitmap

    n := boxes.Size()
    for i := 0; i < n; i++ {
        b := boxes.get(i)
        id := b.id
        visible.set(id)
        shadow := &c.shadowBoxes[id]
        if !shadow.update(b) continue

        var enc coder.Encoder
        enc.Init(msgBuf[:])
        enc.U8(boxUpdate)
        shadow.marshal(id, &enc)
        call(enc.Bytes())
    }

    var enc coder.Encoder
    enc.Init(msgBuf[:])
    enc.U8(boxShow)
    visible.marshal(&enc)
    call(enc.Bytes())

    sendCommit()
}

var theCanvas Canvas

func init() {
    theCanvas.Init()
}

func Get() *Canvas {
    return &theCanvas
}

func PushBoxClasses(classes []*BoxClass) {
    n := len(classes)
    for i := 0; i < n; i++ {
        var enc coder.Encoder
        enc.Init(msgBuf[:])
        enc.U8(boxClassUpdate)
        classes[i].encode(&enc)
        call(enc.Bytes())
    }
}
