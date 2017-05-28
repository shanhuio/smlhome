const nperson = 128

var persons [nperson]person

var pool *person

func initPersonPool() {
    for i := 0; i < nperson; i++ {
        insertPerson(&pool, &persons[i])
    }
}

func allocPerson() *person {
    return removePerson(&pool)
}

func freePerson(p *person) {
    if p != nil {
        insertPerson(&pool, p)
    }
}
