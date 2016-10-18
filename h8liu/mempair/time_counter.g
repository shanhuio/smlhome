struct timeCounter {
    t long.Long
}

func (c *timeCounter) start(t *long.Long) {
    c.t = *t
}

func (c *timeCounter) next(now *long.Long) (int, long.Long) {
    t := *now
    t.Sub(&c.t)
    t.Udiv1e9()
    secs := t.Ival()
    t.Umul1e9()
    ret := c.t
    ret.Add(&t)
    return secs, ret
}
