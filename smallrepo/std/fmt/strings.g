// PrintStr prints a string.
func PrintStr(s string) {
    for i := 0; i < len(s); i++ {
        PrintChar(s[i])
    }
}

func Println() {
    PrintChar('\n')
}
