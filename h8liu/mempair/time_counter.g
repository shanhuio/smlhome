struct timeCounter {
    tstart long.Long
    tstop long.Long
    
    stopped bool
}

func (c *timeCounter) start(t *long.Long) {
    c.tstart = *t
    c.stopped = false
}

func (c *timeCounter) stop(t *long.Long) {
    c.tstop = *t
    c.stopped = true
}

// Returns second reading, nanos to next read, if the counter is stopped.
func (c *timeCounter) read(now *long.Long) (int, long.Long, bool) {
    if c.stopped {
        t := c.tstop
        t.Sub(&c.tstart)
        t.Udiv1e9()
        secs := t.Ival()
        var empty long.Long
        return secs, empty, false
    }
        
    t := *now
    t.Sub(&c.tstart)
    t.Udiv1e9()
    secs := t.Ival()
    t.Umul1e9()
    ret := c.tstart
    ret.Add(&t)
    ret.Sub(now)
    return secs, ret, true
}
