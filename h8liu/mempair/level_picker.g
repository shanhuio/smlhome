struct levelPicker {
}

func (p *levelPicker) render() {
    var prop table.Prop

    prop.Texts[0] = "Pick a level"

    for i := 0; i < 8; i++ {
        c := &prop.Cards[i]
        c.Visible = true
        c.Face = '1' + char(i)
        c.FaceUp = true
    }

    table.Render(&prop)
}
