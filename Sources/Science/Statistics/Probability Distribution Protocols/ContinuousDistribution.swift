//
//  ContinuousDistribution.swift
//
//
//  Created by Lucca de Mello on 2023-04-15.
//

// `ProbabilityDistribution`s have two type parameters: `Statistic` (which must be a floating-point
// type) and `Value` (which, in the general case, can be an integer type or a floating-point type).
// But if the distribution is continuous, its domain covers the real numbers (or a continuous subset
// of them), so the the `Value` must be a floating-point type. There's no reason to use different
// floating-point precisions for the `Statistic` and `Value` type parameters, so we assume that,
// for every `ContinuousDistribution`, the floating-point `Statistic` type and the floating-point
// `Value` type are the same type (hence `where Value == Statistic` below). This assumption
// simplifies conforming to `ContinuousDistribution`, since only one type parameter is necessary.
// The convention in Swift Science is to call this single type parameter (that represents both the
// `Statistic`s and `Value`s of `ContinuousDistribution`s) "RealType". For an example of this, see
// `NormalDistribution`.

/// A [continuous probability distribution].
///
/// [continuous probability distribution]:https://en.wikipedia.org/wiki/Probability_distribution#Absolutely_continuous_probability_distribution
public protocol ContinuousDistribution: ProbabilityDistribution where Value == Statistic {
    /// The probability density function (PDF) of the distribution.
    func probabilityDensity(at value: Value) -> Statistic
}

extension ContinuousDistribution {
    /// The default PMF of continuous distributions. Returns 0 for every `value`.
    public func probability(ofExactly value: Value) -> Statistic { 0 }
}
