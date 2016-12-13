var (
    configs [nlevel]config
    levels [nlevel]game
)

func main() {
    configs[0].noShuffle = true
    configs[2].face = 'a'
    configs[3].timeLimit = 60

    configs[4].failLimit = 3
    configs[4].randSeed = 1

    configs[5].timeBonusCards = true
    configs[5].timeLimit = 30

    configs[6].timeLimit = 30
    configs[6].findSpecial = true

    for i := 0; i < len(levels); i++ {
        levels[i].init(&configs[i])
    }

    var picker levelPicker
    // picker.reach(nlevel)

    for {
        level := picker.pick()

        if levels[level].run() {
            picker.reach(level + 1)
        }

        gap()
    }
}

func gap() {
    var prop table.Prop
    table.Render(&prop)
    var timer time.Timer
    t := time.Now()
    t.Add(&aWhile)
    timer.SetDeadline(&t)
    var s events.Selector
    for {
        ev := s.Select(nil, &timer)
        if ev == events.Timer {
            break
        }
    }
}
