/*
Elevetor scheduling is a turn-based game with 2 elevators.

- Every turn, the elevator can go up, go down, open door, close door, or
  noop. Every action takes one turn. so an elevator can perform only one
  action each turn.
- Every turn, the elevator can set its direction indication: going up,
  down, or idle.
- Elevator with an opening door cannot move.
- When the door is open, passengers inside the elevator that have reached
  his destination will leave the elevator instantly
- Passengers waiting for the elevator will fill the elevator if the direction
  indicator is aligned.
- When two elevators are available, passengers will try to fill the one with
  fewer people, unless the elevator has reached its capacity.
- When two elevators have the same number of passengers inside and both
  has space available, the next passenger will go into a random one.
- Elevator can read the external button state at each floor.
- Elevator can read the internal button state at each floor.
- Elevator can "feel" how many persons is inside the elevator.
- Elevator can see the other elevator's position
*/

var theSim simulator

func main() {
    rand.SysSeed()
    initPersonPool()

    s := &theSim
    s.init(5)

    terminal.SetUseShadow(true)

    for s.now() < 300 {
        s.addPersons()

        terminal.Clear()
        s.printState()

        s.step()
        s.schedule()

        terminal.Commit()
    }
}
