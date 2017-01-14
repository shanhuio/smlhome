import (
    "table"
)

func printWithCards(prop *table.Prop, off int, s string) {
    n := len(s)
    for i := 0; i < n; i++ {
        prop.Cards[off + i].ShowFace(s[i])
    }
}

func main() {
    var prop table.Prop

    printWithCards(&prop, 6, "MERRY")
    printWithCards(&prop, 12, "XMAS")

    table.Render(&prop)
}
