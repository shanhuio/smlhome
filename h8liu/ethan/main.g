import (
    "table"
)

func printWithCards(prop *table.Prop, off int, s string) {
    n := len(s)
    for i := 0; i < n; i++ {
        c := &prop.Cards[off + i]
        c.Face = s[i]
        c.FaceUp = true
        c.Visible = true
    }
}

func main() {
    var prop table.Prop

    printWithCards(&prop, 6, "HELLO")
    printWithCards(&prop, 12, "ETHAN")

    table.Render(&prop)
}
