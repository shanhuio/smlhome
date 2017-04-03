func menu() {
    var prop table.Prop
    prop.Texts[0] = "Click the nums and ops"
    prop.Texts[1] = "to form an expression"
    prop.Texts[2] = "that equals to 24"
    prop.Texts[3] = "C - run, R - backspace"
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
