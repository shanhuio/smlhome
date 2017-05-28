const (
    ActionNoop = 0
    ActionOpenDoor = 1
    ActionCloseDoor = 2
    ActionUp = 3
    ActionDown = 4
)

struct Action {
    Action int
    Direction int
}
