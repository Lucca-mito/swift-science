//
//  Exponential.swift
//  
//
//  Created by Lucca de Mello on 2023-08-01.
//

import RealModule

/// An [exponential distribution].
/// In a process where independent events occur at a constant rate, the amount of time between events follows this distribution.
///
/// [exponential distribution]: https://en.wikipedia.org/wiki/Exponential_distribution
public struct ExponentialDistribution<RealType: Real> {
    public typealias Value = RealType
    public typealias Statistic = RealType
    
    /// The (positive) rate parameter of the exponential distribution, also known as λ.
    public let rate: Statistic
    
    /// Creates an exponential distribution with the given rate.
    /// - Precondition: `rate` > 0
    public init(rate: Statistic) {
        precondition(rate > 0)
        self.rate = rate
    }
}

extension ExponentialDistribution: ProbabilityDistribution {
    /// Whether the exponential distribution is symmetric. Always `false`.
    public var isSymmetric: Bool { false }
    
    /// The cumulative distribution function of the exponential distribution.
    public func probability(ofAtMost value: Value) -> Statistic {
        1 - .exp(-rate * value)
    }
}

extension ExponentialDistribution: ContinuousDistribution {
    /// The probability density function of the exponential distribution.
    public func probabilityDensity(at value: Value) -> Statistic {
        if value >= 0  {
            return rate * .exp(-rate * value)
        } else {
            return 0
        }
    }
}

extension ExponentialDistribution: DistributionWithMoments {
    public var mean: Statistic {
        1 / rate
    }
    
    public var variance: Statistic {
        1 / (rate * rate)
    }
    
    /// The ``DistributionWithMoments/skewness`` of the exponential distribution. Always equal to 2.
    public var skewness: Statistic { 2 }
    
    /// The moment-generating function of the exponential distribution.
    /// - Precondition: `t` < `rate`
    public func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic {
        let t = Statistic(t)
        precondition(t < rate)
        return rate / (rate - t)
    }
}

extension ExponentialDistribution: ClosedFormMedian {
    public var median: Statistic {
        .log(2) / rate
    }
}

extension ExponentialDistribution: ClosedFormQuantile {
    public func quantile(_ quantileFraction: Statistic) -> Value {
        -.log(1 - quantileFraction) / rate
    }
}

extension ExponentialDistribution: Unimodal {
    /// The ``Unimodal/mode`` of the exponential distribution. Always 0.
    public var mode: RealType { 0 }
}

extension ExponentialDistribution: Samplable
where Value: BinaryFloatingPoint, Value.RawSignificand: FixedWidthInteger {}
