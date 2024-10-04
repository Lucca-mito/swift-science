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
public struct NormalDistribution<RealType> where RealType: Real & ExpressibleByFloatLiteral {
    /// The ``DistributionWithMean/mean`` of the normal distribution.
    ///
    /// ## Example
    /// ```swift
    /// let normal = NormalDistribution.standard
    /// print(normal.mean) // 0
    /// ```
    public let mean: RealType
    
    /// The ``DistributionWithVariance/variance`` of the normal distribution.
    ///
    /// ## Example
    /// ```swift
    /// let normal = NormalDistribution(mean: 70, standardDeviation: 3)
    /// print(normal.variance) // 9.0
    /// ```
    public let variance: RealType
    
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
    ///
    /// ## Example
    /// ```swift
    /// let normal = NormalDistribution(mean: 70, variance: 9)
    /// print(normal.standardDeviation) // 3.0
    /// ```
    public let standardDeviation: RealType
    
    /// Creates a normal distribution with the given mean and variance.
    ///
    /// - Parameters:
    ///   - domain: The floating-point type used for values from, and statistics of, this distribution. Defaults to `Double.self` if omitted.
    ///   - mean: The ``mean`` or _expected value_ of the normal distribution, commonly denoted by 𝜇.
    ///   - variance: The ``variance`` of the normal distribution, commonly denoted by 𝜎².
    ///
    /// - Precondition: `variance` > 0
    ///
    /// > See also: ``init(over:mean:standardDeviation:)``
    public init(
        over domain: RealType.Type = Double.self,
        mean: RealType, 
        variance: RealType
    ) {
        precondition(variance > 0)
        
        self.mean = mean
        self.variance = variance
        self.standardDeviation = .sqrt(variance)
    }
    
    /// Creates a normal distribution with the given mean and standard deviation.
    ///
    /// - Parameters:
    ///   - domain: The floating-point type used for values from, and statistics of, this distribution. Defaults to `Double.self` if omitted.
    ///   - mean: The ``mean`` or _expected value_ of the normal distribution, commonly denoted by 𝜇.
    ///   - standardDeviation: The standard deviation of the normal distribution, commonly denoted by 𝜎.
    ///
    /// - Precondition: `standardDeviation` > 0
    ///
    /// > See also: ``init(over:mean:variance:)``
    public init(
        over domain: RealType.Type = Double.self,
        mean: RealType,
        standardDeviation: RealType
    ) {
        precondition(standardDeviation > 0)
        
        self.mean = mean
        self.variance = .pow(standardDeviation, 2)
        self.standardDeviation = standardDeviation
    }
}

extension NormalDistribution where RealType == Double {
    /// The standard normal distribution.
    ///
    /// This is the normal distribution with a ``mean`` of 0 and a ``variance`` of 1.
    ///
    /// The precision is set to the default, `Double`. To create a standard normal distribution with a different precision (such as
    /// `Float`), use the constructor:
    /// ```swift
    /// let normal = NormalDistribution(over: Float.self, mean: 0, variance: 1)
    /// ```
    ///
    /// > See: [Standard normal distribution].
    ///
    /// [Standard normal distribution]: https://en.wikipedia.org/wiki/Normal_distribution#Standard_normal_distribution
    public static var standard: NormalDistribution {
        .init(mean: 0, standardDeviation: 1)
    }
}

extension NormalDistribution: ProbabilityDistribution {
    /// The cumulative distribution function of the normal distribution.
    ///
    /// For the ``standard`` normal distribution, this function is usually denoted by $\operatorname{Φ}(x)$.
    public func probability(ofAtMost value: RealType) -> RealType {
        .erfc(
            (mean - value) /
            (.sqrt(2) * standardDeviation)
        ) / 2
    }
    
    /// Whether the normal distribution is symmetric. Always true.
    public var isSymmetric: Bool { true }
}

extension NormalDistribution: ContinuousDistribution {
    /// The probability density function of the normal distribution.
    ///
    /// The density at $x$ is given by:
    /// $$\frac{1}{\sqrt{2 \pi \sigma^2}} e^{-\frac{(x - \mu)^2}{2 \sigma^2}}$$
    /// Where $\mu$ and $\sigma^2$ are the ``mean`` and ``variance`` of the normal distribution, respectively.
    ///
    /// For the ``standard`` normal distribution, this function is sometimes denoted by $\operatorname{φ}(x)$.
    public func probabilityDensity(at value: RealType) -> RealType {
        let numerator: RealType = .exp(-.pow(value - mean, 2) / variance / 2)
        let denominator: RealType = .sqrt(2 * variance * .pi)
        return numerator / denominator
    }
}

extension NormalDistribution: DistributionWithMoments {
    /// The skewness of the normal distribution. Always 0.
    public var skewness: RealType { 0 }
    
    public func momentGeneratingFunction(_ t: some BinaryInteger) -> RealType {
        precondition(0 <= t)
        let t = RealType(t)
        return .exp(mean * t + variance * .pow(t, 2) / 2)
    }
}

extension NormalDistribution: ClosedFormMedian {
    /// The ``ClosedFormMedian/median`` of the normal distribution. Always equal to its ``NormalDistribution/mean``.
    public var median: RealType { mean }
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
    public func quantile(_ quantileFraction: RealType) -> RealType {
        acklam(p: quantileFraction, standardDeviation: standardDeviation, mean: mean)
    }
}

extension NormalDistribution: Unimodal {
    /// The mode of the normal distribution. Always equal to its ``NormalDistribution/mean``.
    public var mode: RealType { mean }
}

extension NormalDistribution: Samplable
where
    RealType: BinaryFloatingPoint,
    RealType.RawSignificand: FixedWidthInteger
{
    /// Generates a random sample from the normal distribution.
    ///
    /// The sample is generated using the [Box-Muller transform].
    ///
    /// [Box-Muller transform]:https://en.wikipedia.org/wiki/Box–Muller_transform#Basic_form
    public func sample() -> RealType {
        let uniform1 = RealType.random(in: 0 ..< 1)
        let uniform2 = RealType.random(in: 0 ..< 1)
        
        let standardNormalVariate = RealType.sqrt(-2 * .log(uniform1)) * .cos(2 * .pi * uniform2)
        
        return standardNormalVariate * standardDeviation + mean
    }
}
