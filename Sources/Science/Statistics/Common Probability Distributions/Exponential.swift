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
    /// The (positive) rate parameter of the exponential distribution, also known as λ.
    public let rate: RealType
    
    /// Creates an exponential distribution with the given rate.
    /// - Precondition: `rate` > 0
    public init(over domain: RealType.Type = Double.self, rate: RealType) {
        precondition(rate > 0)
        self.rate = rate
    }
}

extension ExponentialDistribution: ProbabilityDistribution {
    /// Whether the exponential distribution is symmetric. Always `false`.
    public var isSymmetric: Bool { false }
    
    /// The cumulative distribution function of the exponential distribution.
    public func probability(ofAtMost RealType: RealType) -> RealType {
        1 - .exp(-rate * RealType)
    }
}

extension ExponentialDistribution: ContinuousDistribution {
    /// The probability density function of the exponential distribution.
    public func probabilityDensity(at RealType: RealType) -> RealType {
        if RealType >= 0  {
            return rate * .exp(-rate * RealType)
        } else {
            return 0
        }
    }
}

extension ExponentialDistribution: DistributionWithMoments {
    public var mean: RealType {
        1 / rate
    }
    
    public var variance: RealType {
        1 / (rate * rate)
    }
    
    /// The ``DistributionWithMoments/skewness`` of the exponential distribution. Always equal to 2.
    public var skewness: RealType { 2 }
    
    /// The moment-generating function of the exponential distribution.
    /// - Precondition: `t` < `rate`
    public func momentGeneratingFunction(_ t: some BinaryInteger) -> RealType {
        let t = RealType(t)
        precondition(t < rate)
        return rate / (rate - t)
    }
}

extension ExponentialDistribution: ClosedFormMedian {
    public var median: RealType {
        .log(2) / rate
    }
}

extension ExponentialDistribution: ClosedFormQuantile {
    public func quantile(_ quantileFraction: RealType) -> RealType {
        -.log(1 - quantileFraction) / rate
    }
}

extension ExponentialDistribution: Unimodal {
    /// The ``Unimodal/mode`` of the exponential distribution. Always 0.
    public var mode: RealType { 0 }
}

extension ExponentialDistribution: Samplable
where RealType: BinaryFloatingPoint, RealType.RawSignificand: FixedWidthInteger {}
