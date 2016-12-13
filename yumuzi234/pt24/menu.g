func menu() {
    var prop table.Prop
    prop.Texts[0] = "Calculate 24"
    prop.Texts[1] = "use four number with +-*/ to calculate 24"
    prop.Texts[2] = "Click numbers and symbols to make the formula"
    prop.Texts[3] = "C to calculate, R to Backspace"
    prop.Buttons[0].Visible = true
    prop.Buttons[0].Text = "start"

    table.Render(&prop)
    var s events.Selector
    for {
        ev := s.Select(nil, nil)
        if ev == events.Click {
            what, pos := s.LastClick()
            if what == table.OnButton {
                if pos == 0 return
            }
        }
    }
}
