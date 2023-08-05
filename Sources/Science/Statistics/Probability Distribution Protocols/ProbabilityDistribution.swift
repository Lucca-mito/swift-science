//
//  ProbabilityDistribution.swift
//
//
//  Created by Lucca de Mello on 2023-04-15.
//

import RealModule

/// A distribution of all possible values of a random variable together with their probabilities.
public protocol ProbabilityDistribution {
    /// The type of values from the distribution.
    associatedtype Value: Comparable
    
    /// The type of probabilities and statistics of the distribution.
    ///
    /// For ``ContinuousDistribution``s, this type is the same as ``Value``.
    associatedtype Statistic: Real
    
    /// Whether the distribution is symmetric.
    ///
    /// For example, every ``NormalDistribution`` is symmetric about its ``DistributionWithMean/mean`` value.
    ///
    /// The distribution does not necessarily have to be symmetric about a *valid* `Value` for `isSymmetric` to be true.
    /// For example, a ``BernoulliDistribution/fair`` ``BernoulliDistribution`` is symmetric about the `Value`
    /// 0.5 even though 0.5 is not a valid `Value` for that distribution.
    var isSymmetric: Bool { get }
    
    /// The probability mass function (PMF) of the distribution, P(𝑋 = `value`).
    /// - Returns: The probability that a random variable following the distribution is exactly equal to `value`.
    ///
    /// For ``ContinuousDistribution``s, this is zero for every `value`.
    func probability(ofExactly value: Value) -> Statistic
    
    /// The cumulative distribution function (CDF) of the distribution, P(𝑋 ≤ `value`).
    /// - Returns: The probability that a random variable following the distribution is less than or equal to `value`.
    func probability(ofAtMost value: Value) -> Statistic
}

// MARK: - Probabilities derived from CDF and PMF.

extension ProbabilityDistribution {
    /// P(𝑋 ≠ `value`)
    public func probability(ofNot value: Value) -> Statistic {
        1 - probability(ofExactly: value)
    }
    
    /// P(𝑋 < `value`)
    public func probability(ofLessThan value: Value) -> Statistic {
        probability(ofAtMost: value) - probability(ofExactly: value)
    }
    
    /// P(𝑋 > `value`)
    public func probability(ofGreaterThan value: Value) -> Statistic {
        1 - probability(ofAtMost: value)
    }
    
    /// P(𝑋 ≥ `value`)
    public func probability(ofAtLeast value: Value) -> Statistic {
        1 - probability(ofLessThan: value)
    }
    
    /// P(𝑋 ∈ `collection`)
    public func probability(ofIn collection: some Collection<Value>) -> Statistic {
        collection.map(probability(ofExactly:)).sum()
    }

    /// P(𝑋 ∈ `range`)
    public func probability(ofIn range: Range<Value>) -> Statistic {
        probability(ofLessThan: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
    
    /// P(𝑋 ∈ `range`)
    public func probability(ofIn range: ClosedRange<Value>) -> Statistic {
        probability(ofAtMost: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
}

extension ProbabilityDistribution where Value: AdditiveArithmetic {
    /// P( |𝑋 − `tolerance` | ≤ `center` )
    public func probability(ofWithin tolerance: Value, from center: Value) -> Statistic {
        probability(ofIn: center - tolerance ... center + tolerance)
    }
}
