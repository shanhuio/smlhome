/*
Elevetor scheduling is a stepped game.
- Every time tick, the elevator can go up, go down, open door, close door, or
  noop
- Elevator with an opening door cannot move
- When an elevator opens the door, it can indicate that it is going up or down
- Human will fill the elevator instantly
- When two elevators are available, human will try to fill the one with fewer
  people
- When two elevators have the same number
- Elevator can read the external button state at each floor.
- Elevator can read the internal button state at each floor.
*/

const MaxFloor = 32

struct Bitmap {
    m uint32
}

struct Lights {
    Dest Bitmap
    NeedUp, NeedDown Bitmap
}

struct State {
    Dests []Bitmap
    NeedUp, NeedDown Bitmap
    Queuing []int
}

struct Person {
    Dest int
    Next *Person
}

struct elevator {
    cur int
}

struct Simulator {
    Dests [2]Bitmap
    NeedUp, NeedDown Bitmap
    Queues []*Person
}

func main() {
}
