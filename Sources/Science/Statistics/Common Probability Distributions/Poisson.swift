//
//  Poisson.swift
//  
//
//  Created by Lucca de Mello on 2023-06-06.
//

import RealModule

/// A [Poisson distribution].
/// In a process where independent events occur at a constant rate, the number of events that occur in a unit of time follows this distribution.
///
/// [Poisson distribution]: https://en.wikipedia.org/wiki/Poisson_distribution
public struct PoissonDistribution<Value, Statistic>
where
    Value: BinaryInteger,

    // The SignedInteger requirement allows us to compute the CDF by summation.
    Value.Stride: SignedInteger,

    // The BinaryFloatingPoint requirement allows us to convert a Statistic to a Value. This is
    // necessary, for example, to compute the mode.
    Statistic: Real & BinaryFloatingPoint
{
    /// The (positive) rate parameter of the Poisson distribution, also known as λ.
    ///
    /// If this Poisson distribution is modeling a counting process, `rate` represents the rate at which events occur in the process.
    /// For example, suppose that a call center receives an average of 3 calls per minute and that the calls are independent from each
    /// other. Then the number of calls received during any given minute follows a Poisson distribution with `rate` 3.
    public let rate: Statistic
    
    /// Creates a Poisson distribution with the given rate.
    /// - Precondition: `rate` > 0
    public init(
        over domain: Value.Type = Int.self,
        withPrecision precision: Statistic.Type = Double.self,
        rate: Statistic
    ) {
        precondition(rate > 0)
        self.rate = rate
    }
}

extension PoissonDistribution: ProbabilityDistribution {
    /// Whether the Poisson distribution is symmetric. Always `false`.
    public var isSymmetric: Bool { false }
    
    /// The probability mass function of the Poisson distribution.
    ///
    /// If the Poisson distribution has ``rate`` λ, then `probability(ofExactly: k)` is:
    ///
    /// ![Lambda to the power of k, times e to the power of negative lambda. Everything divided by k factorial.](poisson-pmf)
    public func probability(ofExactly value: Value) -> Statistic {
        guard value >= 0 else { return 0 }
        
        // `rate` raised to the power of `value`.
        let exponentiated: Statistic
        
        // If possible, cast value from Value to Int (note that Value may already be Int, and
        // usually is) and use the Real.pow overload that takes an Int power.
        if let intValue = Int(exactly: value) {
            exponentiated = .pow(rate, intValue)
        }
        // Otherwise, cast value from Value to Statistic and use the Real.pow overload that takes
        // a Real power.
        else {
           exponentiated = .pow(rate, Statistic(value))
        }
        
        // The desired probability.
        var probability = exponentiated * .exp(-rate)
        
        // If necessary, divide by `value` factorial.
        if value >= 2 {
            // To avoid integer overflow, cast the terms (2...value) to Statistic before multiplying
            // them together.
            probability /= (2...value).map(Statistic.init).reduce(1, *)
        }
        
        return probability
    }
    
    // Use the default (linear-time) implementation of `probability(ofAtMost:)` available to
    // distributions conforming to DiscreteDistribution and LowerBoundedDistribution.
}

extension PoissonDistribution: DiscreteDistribution {}

extension PoissonDistribution: LowerBoundedDistribution {
    /// The lowest ``ProbabilityDistribution/Value`` with a positive probability. Always 0.
    public var min: Value { 0 }
}

extension PoissonDistribution: FiniteModal {
    /// The modes of the Poisson distribution.
    ///
    /// ## Example
    /// Suppose that a call center receives an average of 3 calls per minute and that the calls are independent from each other.
    /// Then the number of calls per minute follows a Poisson distribution with rate 3:
    /// ```swift
    /// let callsPerMinute = PoissonDistribution(rate: 3)
    /// ```
    /// The most likely numbers of calls per minute are 2 and 3:
    /// ```swift
    /// print(callsPerMinute.modes) // [2, 3]
    ///
    /// // Verifying:
    /// print(callsPerMinute.probability(ofExactly: 0)) // Approximately 0.050
    /// print(callsPerMinute.probability(ofExactly: 1)) // Approximately 0.149
    /// print(callsPerMinute.probability(ofExactly: 2)) // Approximately 0.224 <-- Most likely
    /// print(callsPerMinute.probability(ofExactly: 3)) // Approximately 0.224 <-- Most likely
    /// print(callsPerMinute.probability(ofExactly: 4)) // Approximately 0.168
    /// print(callsPerMinute.probability(ofExactly: 5)) // Approximately 0.101
    /// ```
    public var modes: Set<Value> {
        let rateCeil = Value(rate.rounded(.up))
        let rateFloor = Value(rate.rounded(.down))
        return [rateCeil - 1, rateFloor]
    }
}

extension PoissonDistribution: DistributionWithMoments {
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
    /// Generates one random ``ProbabilityDistribution/Value`` sampled from the Poisson distribution.
    /// - Complexity: O(``rate``) on average.
    public func sample() -> Value {
        // Naive algorithm adapted from https://en.wikipedia.org/wiki/Poisson_distribution#Random_variate_generation
        // TODO: Improve. See the implementations in R and in the GNU Scientific Library.
        
        // The eventual return value.
        var result: Value = 0
        
        // The algorithm terminates when `p` exceeds `threshold`.
        var p: Statistic = 1
        let threshold: Statistic = .exp(-rate)
        
        while p > threshold {
            result += 1
            p *= .random(in: 0...1)
        }
        
        return result
    }
}
