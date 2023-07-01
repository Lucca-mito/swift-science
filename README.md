# Swift Science
Swift Science is a scientific computing package for Swift.

## Documentation
Please see [the documentation website](https://lucca-mito.github.io/swift-science/documentation/science).

## Why Swift Science?
### The Swift programming language
Choosing Swift for your scientific code enables it to have both:
- The performance and correctness of a compiled, statically-typed language.
- The abstractions and safety of a modern, high-level language.

If you're new to Swift, learn more about it [here](https://www.swift.org/about). 

### Generics
The Swift Science package has a strong focus on *generic programming*. In most 
packages for scientific computing (for Swift or otherwise), some or all of the functionality is 
locked to a specific point in the precision–performance tradeoff, usually at machine precision. In 
contrast, all functions, structures, and protocols in Swift Science are *generic* over the types 
used for values and statistics. This means that everything in Swift Science has easy-to-use support 
for:
- Extended- and arbitrary-precision floats and integers when you want to prioritize computational accuracy.
- Machine-precision floats (`Double`) and integers (`Int`) by default to prioritize speed.
- `Float16` and `Int8` when you want to prioritize lower memory usage.

And anywhere in between.

## Contributing
This project is very new. All suggestions and contributions are welcome.
