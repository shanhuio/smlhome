func menu() (int, int) {
    var prop table.Prop
    prop.Texts[0] = "Whack a Mole"
    prop.Texts[1] = "click card with 'M'"
    prop.Texts[2] = "avoid card with 'W'"
    prop.Texts[3] = "select a difficulty to start"
    prop.Buttons[0].Visible = true
    prop.Buttons[0].Text = "easy"
    prop.Buttons[1].Visible = true
    prop.Buttons[1].Text = "hard"
    table.Render(&prop)

    var s events.Selector
    for {
        ev := s.Select(nil, nil)
        if ev == events.Click {
            what, pos := s.LastClick()
            if what == table.OnButton {
                if pos == 0 return 1100000000, 2
                return 900000000, 2
            }
        }
    }
}
