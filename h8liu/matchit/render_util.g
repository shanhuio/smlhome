func renderLeft(col int) int {
    return 30 + col * 50
}

func renderTop(row int) int {
    return 30 + row * 50
}

func renderCenterLeft(col int) int {
    ret := renderLeft(col) + 20
    if col == -1 {
        ret += 10
    } else if col == size {
        ret -= 10
    }
    return ret
}

func renderCenterTop(row int) int {
    ret := renderTop(row) + 20
    if row == -1 {
        ret += 10
    } else if row == size {
        ret -= 10
    }
    return ret
}

func renderPos(row, col int) (int, int) {
    return renderLeft(col), renderTop(row)
}

func renderCenterPos(row, col int) (int, int) {
    return renderCenterLeft(col), renderCenterTop(row)
}

func renderSelectPos(row, col int) (int, int) {
    x, y := renderPos(row, col)
    return x - 2, y - 2
}
