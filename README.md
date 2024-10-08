# Swift Science <img src="Resources/swift-science-icon.svg" width="40" style="float: right">
Swift Science is a scientific computing package for Swift.

## Documentation
Please see the [documentation website](https://lucca-mito.github.io/swift-science/documentation/science).

## Why Swift Science?
### The Swift programming language
Choosing Swift for your scientific code enables it to have both:
- The performance and type safety of a compiled, statically-typed language.
- The ease of use and expressivity of a modern, high-level language.

If you're new to Swift, learn more about it [here](https://www.swift.org/about). 

### Generics
The Swift Science package has a strong focus on *generic programming*. In most packages for 
scientific computing (for Swift or otherwise), some or all of the functionality is locked to a 
specific point in the precision–performance tradeoff, usually at machine precision. In contrast, 
all[^1] functions, structures, and protocols in Swift Science are *generic* over the types used for 
values and statistics. This means that everything in Swift Science has easy-to-use support for:
- Extended- and arbitrary-precision floats and integers when you want to prioritize computational accuracy.
- Machine-precision floats (`Double`) and integers (`Int`) by default to prioritize speed.
- `Float16` and `Int8` in resource-constrained or performance-critical environments.

And anywhere in between.

[^1]: The only exception are the structures and functions used for uncertain measurements (in 
uncertainty propagation) and hypothesis testing. These features are fundamentally approximate, so it 
makes little sense to use anything other than machine precision — anything more would be false 
precision — so that is the only supported precision.

## Feature overview
### Hypothesis testing
Currently, the only type of [`HypothesisTest`](https://lucca-mito.github.io/swift-science/documentation/science/hypothesistest) 
that comes built into Swift Science is the [`WaldTest`](https://lucca-mito.github.io/swift-science/documentation/science/waldtest):

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
if WaldTest.sameMean.test(on: (x, y)) == .reject {
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
For continuous types, such as floats and complex numbers, statistics are computed to the same 
precision as the type:
```swift
let data: [Complex<Double>] = [-.i / 2, .exp(1) + .i]

// Type: Complex<Double>
print(data.mean()) // (1.3591409142295225, 0.25)

// Type: Double
print(data.sampleVariance()) // 4.819528049465324
print(data.populationVariance()) // 2.409764024732662
```

For integer data, specify the desired precision of the floating-point mean:
```swift
let data = 0...100

// Type: Double. If omitted, the precision is always Double.
let doublePrecisionMean = data.mean()

// Type: Float16
let halfPrecisionMean = data.mean(toPrecision: Float16.self)

print(doublePrecisionMean, halfPrecisionMean) // 50.0 49.97
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
print(bernoulli.median, bernoulli.max, bernoulli.standardDeviation) // 0 0 0.0
```

### Distribution probabilities
```swift
let normal = NormalDistribution.standard

print(normal.probability(ofWithin: 1, from: 0)) // 0.6826894921370859
print(normal.probability(ofIn: -2...2)) // 0.9544997361036416
print(normal.probability(ofExactly: normal.mode)) // 0

let normalCDF = normal.probability(ofAtMost:)
print(normalCDF(0)) // 0.5
```

### Customizing distribution precision[^2]
```swift
// Type: NormalDistribution<Double>
let doublePrecisionNormal = NormalDistribution(mean: 70, variance: 9)

// Type: NormalDistribution<Float>
let singlePrecisionNormal = NormalDistribution(over: Float.self, mean: 70, variance: 9)
```
[^2]: All probability distributions over floats can have their precision customized (`Double` if 
omitted) and all probability distributions over integers can have their capacity customized (`Int` 
if omitted). So you can, for example, have the domain of any continuous distribution (such as 
`NormalDistribution`) be an arbitrary-precision float type, and you can have the domain of any 
discrete distribution (such as `PoissonDistribution`) be an infinite-capacity integer type.

### Sampling from a distribution
If a [`ProbabilityDistribution`](https://lucca-mito.github.io/swift-science/documentation/science/probabilitydistribution) 
conforms to [`Samplable`](https://lucca-mito.github.io/swift-science/documentation/science/samplable) 
(which all built-in distributions do), you can [`sample`](https://lucca-mito.github.io/swift-science/documentation/science/samplable/sample(count:)) 
random values from them. You can combine this with other Swift Science features, such as sample 
statistics, to run estimation experiments:
```swift
let distribution: some DistributionWithMean & Samplable

let samples = distribution.sample(count: 1_000_000)
let meanEstimate: Double = samples.mean()

print(meanEstimate.isApproximatelyEqual(to: distribution.mean))
```

## Contributing
This project is very new. All suggestions and contributions are welcome.

## Future directions
Please see the [_project plans_](https://github.com/Lucca-mito/swift-science/wiki/Project-plans) 
page of the wiki.
