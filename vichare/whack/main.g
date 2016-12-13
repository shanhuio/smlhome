func main() {
    const misClickLimit = 3
    for {
        interval, step := menu()
        for {
            if !game(interval, step, misClickLimit) break
        }
    }
}
