import (
    "vpc"
    "time"
    "fmt"
)

func main() {
    var t time.Time

    for i := 0; i < 10; i++ {
        time.Now(&t)
        t.Print()
        fmt.PrintStr("--\n")
    }
}
