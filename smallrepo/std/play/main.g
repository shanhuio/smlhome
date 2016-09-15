import (
    "vpc"
    "time"
    "fmt"
)

func main() {
    var t time.Time

    for i := 0; i < 10; i++ {
        vpc.TimeNow(&t)
        t.Print()
        fmt.PrintStr("--\n")
    }
}
