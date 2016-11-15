struct timeChange {
    interval int
    change int
}

func (d *timeChange) set(i int, c int) {
    d.interval = i
    d.change = c
}

func (d *timeChange) move() {
    d.interval = d.interval / 100 * (100 - d.change)
}

func (d *timeChange) inter() int {
    return d.interval
}
