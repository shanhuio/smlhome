struct Ticker {
    start long.Long
    interval long.Long
    nextTick long.Long
    counter int
    updated bool
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
    t.updated = true
    t.nextTick.Add(&t.interval)
    return true
}

func (t *Ticker) Forward(now *long.Long) {
    if !t.running return
    for t.forwardOne(now) {}
}

func (t *Ticker) Poll() bool {
    if !t.updated return false
    t.updated = false
    return true
}

func (t *Ticker) N() int {
    return t.counter
}

func (t *Ticker) Stop() {
    t.running = false
}

func (t *Ticker) SetTimeout(timeout *Timeout) bool {
    if !t.running return false
    return timeout.Set(&t.nextTick)
}
