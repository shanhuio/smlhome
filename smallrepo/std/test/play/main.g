import (
    "vpc"
    "fmt"
    "long"
)

var msg [1000]byte

func main() {
    var dur long.Long
    dur.Iset(1000000000)
    var ts long.Long

    for i := 0; i < 10; i++ {
        service, _, err := vpc.Poll(&dur, msg[:])
        fmt.PrintUint(service)
        fmt.Println()
        fmt.PrintInt(err)
        fmt.Println()

        vpc.TimeElapsed(&ts)
        fmt.PrintUint(ts.Hi)
        fmt.Println()
        fmt.PrintUint(ts.Lo)
        fmt.Println()
        fmt.PrintStr("----\n")
    }
}
