var e RationalNum

func parseNum(c char) (RationalNum, bool) {
    var r RationalNum
    if c >= '0' && c <= '9' {
        a := int(c - '0')
        r.SetInt(a)
        return r, true
    }
    return e, false
}

struct parser {
    s string
    pos int
}

func (p *parser) current() char {
    if p.pos >= len(p.s) return '\x00'
    return p.s[p.pos]
}

func (p *parser) next() char {
    ret := p.current()
    p.pos++
    return ret
}

// example: 3
func (p *parser) parseNum() (RationalNum, bool) {
    return parseNum(p.next())
}

func (p *parser) parseExpr() (RationalNum, bool) {
    return p.parseAddSub()
}

func (p *parser) parseParen() (RationalNum, bool) {
    p.next() // consume '('
    ret, ok := p.parseExpr()
    if !ok return e, false
    if p.next() != ')' return e, false
    return ret, true
}

// example: 3, (xxx)
func (p *parser) parsePrimary() (RationalNum, bool) {
    c := p.current()
    if c == '(' return p.parseParen()
    return p.parseNum()
}

// example: 3, 3+4, 3+4+5, 3+(4)+5, 3+4*5+5*6/7
func (p *parser) parseAddSub() (RationalNum, bool) {
    a, ok := p.parseMulDiv()
    if !ok return e, false
    for {
        c := p.current()
        if !(c == '+' || c == '-') return a, true

        p.next()
        b, ok := p.parseMulDiv()
        if !ok return e, false
        if c == '+' {
            a.Add(&b)
        } else { // c == '-'
            a.Sub(&b)
        }
    }
}

// example: 3, 3*4, 3*4/5
func (p *parser) parseMulDiv() (RationalNum, bool) {
    a, ok := p.parsePrimary()
    if !ok return e, false
    for {
        c := p.current()
        if !(c == '*' || c == '/') return a, true

        p.next()
        b, ok := p.parsePrimary()
        if !ok return e, false
        if c == '*' {
            a.Mul(&b)
        } else { // c == '/'
            a.Div(&b)
        }
    }
}

func parse24(s string) (RationalNum, bool) {
    var p parser
    p.s = s
    ret, ok := p.parseExpr()
    if !ok return e, false
    if p.current() != '\x00' return e, false
    return ret, true
}

func parse24OrDie(s string) int {
    ret, ok := parse24(s)
    if !ok {
        panic()
    }
    if ret.d != 1 {
        panic()
    }
    return ret.n
}

func checkValid(s string) bool {
    _, ok := parse24(s)
    return ok
}

func TestParse() {
    assert(parse24OrDie("3") == 3)
    assert(parse24OrDie("(3)") == 3)
    assert(parse24OrDie("3*4") == 12)
    assert(parse24OrDie("3-4") == -1)
    assert(parse24OrDie("3+4") == 7)
    assert(parse24OrDie("3+4*5") == 23)
    assert(parse24OrDie("4*5+3") == 23)
    assert(parse24OrDie("4*(5+3)") == 32)
    assert(parse24OrDie("4*(5+3*1)") == 32)

    assert(!checkValid(""))
    assert(!checkValid(")"))
    assert(!checkValid("("))
    assert(!checkValid("()"))
    assert(!checkValid("1234"))
    assert(!checkValid("+1"))
    assert(!checkValid("-1"))
    assert(!checkValid("(5"))
    assert(!checkValid("5)"))
    assert(!checkValid("(5))"))
}
