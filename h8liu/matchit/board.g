const size = 8

const nblock = size * size

func rowCol(p int) (int, int) {
    return p / size, p % size
}

func makePos(row, col int) int {
    return row * size + col
}
