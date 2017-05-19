const nlift = 2

const nfloor = 30

struct person {
    dest int
    next *person
}

struct personList {
    first *person
}

struct lift {
    floor int
    doorOpen bool
    passengers personList
    buttons uint32
    direction int // 1 for up, 0 for noop, -1 for down
}

struct floor {
    queue personList
    buttonUp bool
    buttonDown bool
}

struct simulator {
    lifts [nlift]lift
    floors [nfloor]floor
}
