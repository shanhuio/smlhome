var (
    configs [nlevel]config
    levels [nlevel]game
)

func main() {
    fmt.PrintStr("Mem pair\n")

    configs[0].noShuffle = true
    configs[2].face = 'a'
    configs[3].timeLimit = 60

    configs[4].failLimit = 3
    configs[4].randSeed = 1

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

        // wait for a click
        var s selector
        s.Select(nil, nil)
    }
}
