# Starts From Here (draft)

I plan to build a compiler that compiles [Go language][1] to [Web Assembly][2].
I will share the entire building journey here at my new little tech blog
system.

[1]: https://golang.org/
[2]: http://webassembly.org/

## Web Assembly

[Web Assembly][1] is essentially a new binary executable format that is
going to be supported by most of the popular browsers. This not only enables
native performance Web applications that runs instantly without explicit 
installations, but also provides a chance for Web developers to use more
advanced compilers and better software development procedures, which are 
critical to develop large applications. Therefore, I think Web Assembly is
a very cool idea, which might eventually evolve into a brand new meta for
the online world. I am excited.

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

In short, I have two goals:

- Translate the existing [G language compiler][5] from Go to G, so that the
compiler becomes self hosting.
- Add a new G language compiler backend for Web Assembly. 

(For those of you that are interested, there is [an issue on GitHub][4] that
tracks the discussion on building a Web Assembly backend for Go language.)

[4]: https://github.com/golang/go/issues/18892
[5]: https://github.com/shanhuio/smlvm/

## A Coding Show

I want to make this journey a show of coding, and hence it is important for the
show followers to understand the code that I am writing. For that, this tech
blog will also serve as a code repository that stores and compiles all the G
language code that I write for this project, where visitors can easily
read and run the code right inside the browser.

Furthermore, to make sure that the high level project structure can be clearly
presented, the project will follow two basic rules:

1. No file can be more than 300 lines, where each line has maximum 80 
   characters.
2. No circular dependencies among files.

The first rule makes sure that the project is divided into small
comprehensible units. For example, it make sure that there is no function body
or type definition in the project that has more than 300 lines.

The second rule makes sure that the small project units are organized in
multiple layers rather than a pile of huge monolithic spaghetti-like blob.


