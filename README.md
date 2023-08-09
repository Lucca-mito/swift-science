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

## Feature overview
### Hypothesis testing
Currently, the only type of [`HypothesisTest`](https://lucca-mito.github.io/swift-science/documentation/science/hypothesistest) that comes built into Swift Science is the [`WaldTest`](https://lucca-mito.github.io/swift-science/documentation/science/waldtest):

```swift
let data: [Double]

// Test whether a population mean equals 𝜋.
let wald = WaldTest(doesMeanEqual: .pi)

print(wald.test(on: data))
print(wald.pValue(for: data))
```

```swift
let x: [Double]
let y: [Double]

// Test whether two populations have the same mean.
if WaldTest.sameMean.test(on: [x, y]) == .reject {
    print("The means (probably) differ!")
}
```

But you can design your own, custom hypothesis tests:
```swift
let customTest = createHypothesisTest(…)

print(customTest.test(on: data))
print(customTest.pValue(for: data))
```

Built-in support for (at least) the *t*-test is part of the near-future plans for the project.

### Sample statistics
For continuous types, such as floats and complex numbers, statistics are computed to the same precision as the type:
```swift
let data: [Complex<Double>] = [-.i / 2, .exp(1) + .i]

// Type: Complex<Double>
print(data.mean()) // (1.3591409142295225, 0.25)

// Type: Double
print(data.sampleVariance()) // 4.819528049465324
print(data.populationVariance()) // 2.409764024732662
```

For integer types, specify the desired precision:
```swift
let data = 0...100
let halfPrecision: Float16 = data.mean()
let doublePrecision: Double = data.mean()
print(halfPrecision, doublePrecision) // 49.97 50.0
```

### Distribution statistics
```swift
let poisson = PoissonDistribution(rate: 3)

print(poisson.modes) // [2, 3]
print(poisson.skewness == 1 / .sqrt(3)) // true
print(poisson.momentGeneratingFunction(2).rounded()) // 210957721.0
```
```swift
print(BernoulliDistribution.domain) // [0, 1]

let bernoulli = BernoulliDistribution(probabilityOfOne: 0)

print(bernoulli.support) // [0]
print(bernoulli.median) // 0
print(bernoulli.standardDeviation) // 0.0
```

### Sampling from a distribution
If a [`ProbabilityDistribution`](https://lucca-mito.github.io/swift-science/documentation/science/probabilitydistribution) conforms to [`Samplable`](https://lucca-mito.github.io/swift-science/documentation/science/samplable) (which all built-in distributions do), you can [`sample`](https://lucca-mito.github.io/swift-science/documentation/science/samplable/sample(count:)) random values from them. You can combine this with other Swift Science features, such as sample statistics, to run estimation experiments:
```swift
let distribution: some DistributionWithMean & Samplable

let samples = distribution.sample(count: 1_000_000)
let meanEstimate: Double = samples.mean()

print(meanEstimate.isApproximatelyEqual(to: distribution.mean))
```

## Contributing
This project is very new. All suggestions and contributions are welcome.

## Future directions
Please see the [_project plans_](https://github.com/Lucca-mito/swift-science/wiki/Project-plans) page of the wiki.
