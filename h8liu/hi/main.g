import (
    "dialog"
)

func main() {
    dialog.Say("Hello")

    var ch [3]string
    ch[0] = "Good"
    ch[1] = "Fine, thanks. And you?"
    ch[2] = "Not so well."

    ans := dialog.AskChoice("How are you today?", ch[:], 3)

    switch ans {
    case 0:
        dialog.Say("...")
    case 1:
        dialog.Say("I'm fine too.")
    case 2:
        dialog.Say("Look at the bright side. Get better soon.")
    default:
        dialog.Say("Well, I will ask you again then.")
    }
}
