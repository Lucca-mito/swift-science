//
//  Normal.swift
//  
//
//  Created by Lucca de Mello on 2023-04-15.
//

import RealModule

/// A [normal distribution], also known as a Gaussian distribution.
///
/// [normal distribution]: https://en.wikipedia.org/wiki/Normal_distribution
public struct NormalDistribution<Statistic: Real> {
    /// The ``DistributionWithMean/mean`` of the normal distribution.
    /// ## Example
    /// ```swift
    /// let normal = NormalDistribution.standard
    /// print(normal.mean) // 0
    /// ```
    public let mean: Statistic
    
    /// The variance of the normal distribution.
    public let variance: Statistic
    
    // NormalDistribution conforms to DistributionWithVariance via Moments; see below.
    // As a result, NormalDistribution inherits the default implementation of standardDeviation (as
    // the computed property `.sqrt(variance)`) defined in DistributionWithVariance.
    //
    // However, it's common for normal distributions to be initialized with a standard deviation
    // instead of a variance. So keeping standardDeviation as the computed property `.sqrt(variance)`
    // would often involve an unecessary computation step. This is why NormalDistribution overrides
    // the default (computed) implementation of standardDeviation with this stored property:
    /// The standard deviation of the normal distribution.
    public let standardDeviation: Statistic
    
    /// Creates a normal distribution with the given mean and variance.
    ///
    /// > See also: ``init(mean:standardDeviation:)``
    public init(mean: Statistic, variance: Statistic) {
        self.mean = mean
        self.variance = variance
        self.standardDeviation = .sqrt(variance)
    }
    
    /// Creates a normal distribution with the given mean and standard deviation.
    ///
    /// > See also: ``init(mean:variance:)``
    public init(mean: Statistic, standardDeviation: Statistic) {
        self.mean = mean
        self.variance = .pow(standardDeviation, 2)
        self.standardDeviation = standardDeviation
    }
}

extension NormalDistribution {
    /// The standard normal distribution.
    ///
    /// This is the normal distribution with a ``mean`` of 0 and a ``variance`` of 1.
    /// > See: [Standard normal distribution].
    ///
    /// [Standard normal distribution]: https://en.wikipedia.org/wiki/Normal_distribution#Standard_normal_distribution
    public static var standard: NormalDistribution {
        NormalDistribution(mean: 0, standardDeviation: 1)
    }
}

extension NormalDistribution: ContinuousDistribution {
    public func probabilityDensity(at value: Statistic) -> Statistic {
        let numerator: Statistic = .exp(-.pow(value - mean, 2) / variance / 2)
        let denominator: Statistic = .sqrt(2 * variance * .pi)
        return numerator / denominator
    }
    
    public func probability(ofAtMost value: Statistic) -> Statistic {
        .erfc(
            (mean - value) /
            (.sqrt(2) * standardDeviation)
        ) / 2
    }
    
    public var isSymmetric: Bool { true }
}

extension NormalDistribution: Moments {
    public var skewness: Statistic { 0 }
    
    public func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic {
        precondition(0 <= t)
        let t = Statistic(t)
        return .exp(mean * t + variance * .pow(t, 2) / 2)
    }
}

extension NormalDistribution: ClosedFormMedian {
    public var median: Statistic { mean }
}

extension NormalDistribution: Unimodal {
    public var mode: Statistic { mean }
}

extension NormalDistribution: Samplable
where
    Statistic: BinaryFloatingPoint,
    Statistic.RawSignificand: FixedWidthInteger
{
    /// Generates a random sample from the normal distribution.
    ///
    /// The sample is generated using the [Box-Muller transform].
    ///
    /// [Box-Muller transform]:https://en.wikipedia.org/wiki/Box–Muller_transform#Basic_form
    public func sample() -> Value {
        let uniform1 = Value.random(in: 0..<1)
        let uniform2 = Value.random(in: 0..<1)
        return .sqrt(-2 * .log(uniform1)) * .cos(2 * .pi * uniform2)
    }
}
