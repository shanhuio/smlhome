# Starts From Here (draft)

I plan to build a compiler that compiles [Go language][1] to [Web Assembly][2].
I will share the entire building journey here at my new little tech blog
system.

[1]: https://golang.org/
[2]: http://webassembly.org/

## Web Assembly

[Web Assembly][1] is essentially a new binary executable format that is
going to be supported by most of the popular browsers. This not only enables
Web applications with native performance, but also provides a chance for Web
developers to use more advanced compilers and better software development 
procedures, which are critical to develop large applications. Therefore, 
I think Web Assembly is a very cool idea, which might eventually evolve into
a brand new meta for the online world. I am excited about it.

Because Web Assembly is relatively new, only several languages support it now.
The big ones are C, C++, and [Rust][3]. It will be fun to add some more into
the family.

[3]: https://www.rust-lang.org/en-US/ 

## Go?

OK, I lied. I love Go language, but I am not going to build a full-fledged Go
compiler. Compiling Go language to Web Assembly is probably a project
too complicated to complete by myself, and might not have so much fun in it.

Instead, I am going to compile a language that I designed based on
Go. I call it **G** language, because it is very much a Go language subset.

I already have a basic [G language compiler][5] written in Go, and it powers
this tech blog for compiling and running G language programs.
However, it currently compiles to a small virtual machine instruction set
rather than Web Assembly, so the performance is horrible.

Here is the plan to make it better:

- Translate the existing [G language compiler][5] from Go to G, so that the
compiler becomes self hosting.
- Add a new G language compiler backend for Web Assembly. 

(For those of you that are interested, there is [an issue on GitHub][4] that
tracks the discussion on building a Web Assembly backend for Go language.)

[4]: https://github.com/golang/go/issues/18892
[5]: https://github.com/shanhuio/smlvm/

## Coding Rules

I will share the building procedure of this project on this blog, which also
serves as a code repository that stores and compiles all the G language code.

Furthermore, to make it easier for readers to understand the code,
I set two rules:

1. No file can be more than 300 lines, where each line has maximum 80 
   characters.
2. No circular dependencies among files.

The first rule makes sure that the project is divided into small
comprehensible units. For example, it make sure that there is no function body
or type definition in the project that has more than 300 lines.

The second rule makes sure that the small project units are organized in
structured abstraction layers, rather than a pile of huge monolithic
spaghetti-like blob.

These two rules are enforced by the compiler. The compiler will fail with
compile time errors if either of them is not satisfied.

One nice thing of following these rules: it enables visualizing the project
structure into [figures like this][6] for easier code navigation.

[6]: https://shanhu.io/smlvm

Even for a custom small language, this project is still fairly complicated 
and will take a lot of time to finish. In fact, when it is eventually
finished, I am not sure if Web Assembly will still be a thing. However, 
what makes this interesting for me is not just the end results, but also
the procedure of building it, and sharing this experience online with all
types of hackers, friends and strangers.

I am super excited.
