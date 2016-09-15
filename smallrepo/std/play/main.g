import (
    "vpc"
    "fmt"
	"long"
)

func main() {
	var ts long.Long

    for i := 0; i < 10; i++ {
        vpc.Timestamp(&ts)
		fmt.PrintUint(ts.Hi)
		fmt.Println()
		fmt.PrintUint(ts.Lo)
		fmt.Println()
    }
}
