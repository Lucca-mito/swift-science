//
//  LowerBoundedDistribution.swift
//  
//
//  Created by Lucca de Mello on 6/6/23.
//

/// A probability distribution with a lower bound.
public protocol LowerBoundedDistribution: ProbabilityDistribution {
    /// The lowest ``ProbabilityDistribution/Value`` with a positive probability.
    var min: Value { get }
}

extension LowerBoundedDistribution
where
    Self: DiscreteDistribution,
    Value: BinaryInteger,
    Value.Stride: SignedInteger
{
    /// The cumulative density function of the distribution.
    ///
    /// - Complexity: O(`value`)
    ///
    /// This is a default implementation of the cumulative density function for discrete distributions with a lower bound. It simply sums
    /// ``ProbabilityDistribution/probability(ofExactly:)`` from ``min`` to `value`, so it takes linear time.
    /// For this reason, probability distributions are encouraged to override this default implementation with a closed-form solution if one
    /// exists.
    public func probability(ofAtMost value: Value) -> Statistic {
        (min...value).map(probability(ofExactly:)).sum()
    }
}
