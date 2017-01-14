func rowSpan(b []*block, row, col int) (int, int) {
    min := row
    for {
        r := min - 1
        if r < 0 {
            min = -1
            break
        }
        if b[makePos(r, col)].visible break
        min--
    }

    max := row
    for {
        r := max + 1
        if r >= size {
            max = size
            break
        }
        if b[makePos(r, col)].visible break
        max++
    }

    return min, max
}

func colSpan(b []*block, row, col int) (int, int) {
    min := col
    for {
        c := min - 1
        if c < 0 {
            min = -1
            break
        }

        if b[makePos(row, c)].visible break
        min--
    }

    max := col
    for {
        c := max + 1
        if c >= size {
            max = size
            break
        }

        if b[makePos(row, c)].visible break
        max++
    }

    return min, max
}

func intersect(min1, max1, min2, max2 int) (int, int, bool) {
    min := min1
    if min2 > min {
        min = min2
    }

    max := max1
    if max2 < max {
        max = max2
    }

    if min > max return 0, 0, false
    return min, max, true
}

func colReach(b []*block, row, c1, c2 int) bool {
    if row == -1 return true
    if row == size return true
    if c1 == c2 return true
    if c1 > c2 {
        c1, c2 = c2, c1
    }

    for c := c1 + 1; c < c2; c++ {
        if b[makePos(row, c)].visible return false
    }
    return true
}

func rowReach(b []*block, col, r1, r2 int) bool {
    if col == -1 return true
    if col == size return true
    if r1 == r2 return true
    if r1 > r2 {
        r1, r2 = r2, r1
    }

    for r := r1 + 1; r < r2; r++ {
        if b[makePos(r, col)].visible return false
    }
    return true
}

func matchCheck(b []*block, p1, p2 int) (int, int, int, int, bool) {
    var it iter

    r1, c1 := rowCol(p1)
    r2, c2 := rowCol(p2)

    r1min, r1max := rowSpan(b, r1, c1)
    r2min, r2max := rowSpan(b, r2, c2)
    rmin, rmax, rowOk := intersect(r1min, r1max, r2min, r2max)
    if rowOk {
        if c1 == c2 return r1, c1, r2, c2, true

        rs := it.build(r1, r2, rmin, rmax)
        n := len(rs)
        for i := 0; i < n; i++ {
            r := rs[i]
            if colReach(b, r, c1, c2) return r, c1, r, c2, true
        }
    }

    c1min, c1max := colSpan(b, r1, c1)
    c2min, c2max := colSpan(b, r2, c2)
    cmin, cmax, colOk := intersect(c1min, c1max, c2min, c2max)
    if colOk {
        if r1 == r2 return r1, c1, r2, c2, true

        cs := it.build(c1, c2, cmin, cmax)
        n := len(cs)
        for i := 0; i < n; i++ {
            c := cs[i]
            if rowReach(b, c, r1, r2) return r1, c, r2, c, true
        }
    }

    return 0, 0, 0, 0, false
}
