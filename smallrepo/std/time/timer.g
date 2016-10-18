struct Timer {
    deadline long.Long
    running bool
    triggered bool
}

func (t *Timer) restart() {
    t.running = true
    t.triggered = false
}

func (t *Timer) Set(now, d *long.Long) {
    t.deadline = *now
    t.deadline.Add(d)
    t.restart()
}

func (t *Timer) SetDeadline(d *long.Long) {
    t.deadline = *d
    t.running = true
    t.restart()
}

func (t *Timer) Forward(now *long.Long) {
    if !t.running return
    if !now.LargerThan(&t.deadline) return
    t.triggered = true
}

func (t *Timer) Triggered() bool {
    return t.triggered
}

func (t *Timer) Clear() {
    t.running = false
    t.triggered = false
}

func (t *Timer) NextEvent(next *long.Long) bool {
    if !t.running return false
    if t.triggered return false
    if t.deadline.LargerThan(next) return false
    *next = t.deadline
    return true
}
