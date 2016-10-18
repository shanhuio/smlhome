struct Ticker {
    start long.Long
    interval long.Long
    nextTick long.Long
    counter int
    running bool
}

func (t *Ticker) Clear() {
    t.counter = 0
    t.running = false
}

func (t *Ticker) Running() bool {
    return t.running
}

func (t *Ticker) Start(now, interval *long.Long) {
    t.start = *now
    t.interval = *interval
    t.nextTick = *now
    t.nextTick.Add(interval)
    t.running = true
    t.counter = 0
}

func (t *Ticker) forwardOne(now *long.Long) bool {
    if !now.LargerThan(&t.nextTick) return false
    t.counter++
    t.nextTick.Add(&t.interval)
    return true
}

func (t *Ticker) Forward(now *long.Long) {
    if !t.running return
    for t.forwardOne(now) {}
}

func (t *Ticker) N() int {
    return t.counter
}

func (t *Ticker) Stop() {
    t.running = false
}

func (t *Ticker) NextEvent(next *long.Long) bool {
    if !t.running return false
    if t.nextTick.LargerThan(next) return false
    *next = t.nextTick
    return true
}
