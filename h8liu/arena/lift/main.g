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

var theSim simulator

func main() {
    rand.SysSeed()
    initPersonPool()

    s := &theSim
    s.init(3)

    for s.now() < 300 {
        fmt.PrintStr("T=")
        fmt.PrintInt(s.now())
        fmt.Println()

        s.addPersons()

        s.printState()
        fmt.PrintStr("-----")
        fmt.Println()

        s.step()
        s.schedule()
    }
}
