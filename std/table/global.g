var theTable table

func init() {
    theTable.init()
}

func Render(p *Prop) {
    theTable.update(p)
    theTable.render()
}
