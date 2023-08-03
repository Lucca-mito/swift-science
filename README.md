# Swift Science <img src="Resources/swift-science-icon.svg" width="40" style="float: right">
Swift Science is a scientific computing package for Swift.

## Documentation
Please see the [documentation website](https://lucca-mito.github.io/swift-science/documentation/science).

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
contrast, all[^1] functions, structures, and protocols in Swift Science are *generic* over the types 
used for values and statistics. This means that everything in Swift Science has easy-to-use support 
for:
- Extended- and arbitrary-precision floats and integers when you want to prioritize computational accuracy.
- Machine-precision floats (`Double`) and integers (`Int`) by default to prioritize speed.
- `Float16` and `Int8` when you want to prioritize lower memory usage.

And anywhere in between.

[^1]: The only exception are the structures and functions used for uncertain measurements (in 
uncertainty propagation) and hypothesis testing. These features are fundamentally approximate, so it 
makes little sense to use anything other than machine precision — anything more would be false 
precision — so that is the only supported precision.

## Contributing
This project is very new. All suggestions and contributions are welcome.

## Future directions
Please see the [_project plans_](https://github.com/Lucca-mito/swift-science/wiki/Project-plans) page of the wiki.
