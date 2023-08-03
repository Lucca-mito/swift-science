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
public struct NormalDistribution<Statistic> where Statistic: Real & ExpressibleByFloatLiteral {
    /// The ``DistributionWithMean/mean`` of the normal distribution.
    /// ## Example
    /// ```swift
    /// let normal = NormalDistribution.standard
    /// print(normal.mean) // 0
    /// ```
    public let mean: Statistic
    
    /// The variance of the normal distribution.
    public let variance: Statistic
    
    // NormalDistribution conforms to DistributionWithVariance via DistributionWithMoments (see
    // below). As a result, NormalDistribution inherits the default implementation of
    // standardDeviation (as the computed property `.sqrt(variance)`) defined in
    // DistributionWithVariance.
    //
    // However, it's common for normal distributions to be initialized with a standard deviation
    // instead of a variance. So keeping standardDeviation as the computed property
    // `.sqrt(variance)` would often involve an unecessary computation step. This is why
    // NormalDistribution overrides the default (computed) implementation of standardDeviation with
    // this stored property:
    /// The standard deviation of the normal distribution.
    public let standardDeviation: Statistic
    
    /// Creates a normal distribution with the given mean and variance.
    ///
    /// - Precondition: `variance` > 0
    ///
    /// > See also: ``init(mean:standardDeviation:)``
    public init(mean: Statistic, variance: Statistic) {
        precondition(variance > 0)
        
        self.mean = mean
        self.variance = variance
        self.standardDeviation = .sqrt(variance)
    }
    
    /// Creates a normal distribution with the given mean and standard deviation.
    ///
    /// - Precondition: `standardDeviation` > 0
    ///
    /// > See also: ``init(mean:variance:)``
    public init(mean: Statistic, standardDeviation: Statistic) {
        precondition(standardDeviation > 0)
        
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

extension NormalDistribution: ProbabilityDistribution {
    /// The probability density function of the normal distribution.
    ///
    /// For the ``standard`` normal distribution, this function is usually denoted by Φ(𝑥).
    public func probability(ofAtMost value: Statistic) -> Statistic {
        .erfc(
            (mean - value) /
            (.sqrt(2) * standardDeviation)
        ) / 2
    }
    
    /// Whether the normal distribution is symmetric. Always true.
    public var isSymmetric: Bool { true }
}

extension NormalDistribution: ContinuousDistribution {
    /// The cumulative density function of the normal distribution.
    ///
    /// For the ``standard`` normal distribution, this function is sometimes denoted by φ(𝑥).
    public func probabilityDensity(at value: Statistic) -> Statistic {
        let numerator: Statistic = .exp(-.pow(value - mean, 2) / variance / 2)
        let denominator: Statistic = .sqrt(2 * variance * .pi)
        return numerator / denominator
    }
}

extension NormalDistribution: DistributionWithMoments {
    /// The ``DistributionWithMoments/skewness`` of the normal distribution. Always 0.
    public var skewness: Statistic { 0 }
    
    /// The moment-generating function of the normal distribution.
    public func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic {
        precondition(0 <= t)
        let t = Statistic(t)
        return .exp(mean * t + variance * .pow(t, 2) / 2)
    }
}

extension NormalDistribution: ClosedFormMedian {
    /// The median of the normal distribution. Always equal to its ``NormalDistribution/mean``.
    public var median: Statistic { mean }
}

extension NormalDistribution: ClosedFormQuantile {
    /// The inverse normal CDF.
    ///
    /// The case for the standard normal distribution is known as the [probit] function.
    ///
    /// The function is computed using [Acklam's algorithm].
    ///
    /// [probit]: https://en.wikipedia.org/wiki/Probit
    /// [Acklam's algorithm]: https://web.archive.org/web/20151030215612/http://home.online.no/~pjacklam/notes/invnorm
    public func quantile(_ quantileFraction: Statistic) -> Statistic {
        acklam(p: quantileFraction, standardDeviation: standardDeviation, mean: mean)
    }
}

extension NormalDistribution: Unimodal {
    /// The mode of the normal distribution. Always equal to its ``NormalDistribution/mean``.
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
        
        let standardNormalVariate = Value.sqrt(-2 * .log(uniform1)) * .cos(2 * .pi * uniform2)
        
        return standardNormalVariate * standardDeviation + mean
    }
}
