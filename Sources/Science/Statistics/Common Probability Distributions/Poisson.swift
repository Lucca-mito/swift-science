//
//  Poisson.swift
//  
//
//  Created by Lucca de Mello on 6/6/23.
//

import RealModule

/// A [Poisson distribution].
///
/// [Poisson distribution]: https://en.wikipedia.org/wiki/Poisson_distribution
public struct PoissonDistribution<Value, Statistic>
where
    Value: BinaryInteger,

    // This additional requirement allows us to compute the CDF by summation.
    Value.Stride: SignedInteger,

    Statistic: Real
{
    /// The (positive) rate parameter, also known as λ.
    public let rate: Statistic
    
    /// Creates a Poisson distribution with the given rate.
    ///
    /// - Precondition: `rate` > 0
    public init(rate: Statistic) {
        precondition(rate > 0)
        self.rate = rate
    }
}

extension PoissonDistribution: DiscreteDistribution {
    public var isSymmetric: Bool { false }
    
    public func probability(ofExactly value: Value) -> Statistic {
        // `rate` raised to the power of `value`.
        let exponentiated: Statistic
        
        if let value = Int(exactly: value) {
            exponentiated = .pow(rate, value)
        } else {
           exponentiated = .pow(rate, Statistic(value))
        }
        
        return exponentiated * .exp(-rate)
    }
    
    // Use the default (linear-time) implementation of `probability(ofAtMost:)`.
}

extension PoissonDistribution: LowerBoundedDistribution {
    public var min: Value { 0 }
}

extension PoissonDistribution: Moments {
    public var mean: Statistic { rate }
    
    public var variance: Statistic { rate }
    
    public var skewness: Statistic { 1 / .sqrt(rate) }
    
    public func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic {
        let t = Statistic(t)
        return .exp(rate * (.exp(t) - 1))
    }
}

extension PoissonDistribution: Samplable
where
    Statistic: BinaryFloatingPoint,
    Statistic.RawSignificand: FixedWidthInteger
{
    public func sample() -> Value {
        fatalError("TODO")
    }
}
