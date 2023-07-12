//
//  BoundedDiscreteDistribution.swift
//
//
//  Created by Lucca de Mello on 2023-04-23.
//

/// A probability distribution over a finite set of values.
///
/// Such a distribution always has a ``DistributionWithMean/mean``, a ``DistributionWithVariance/variance``,
/// and all other ``Moments``. Additionally, a `BoundedDiscreteDistribution` always has a ``ClosedFormQuantile``.
public protocol BoundedDiscreteDistribution:
    DiscreteDistribution, BoundedDistribution, Moments, ClosedFormQuantile
{
    /// The finite set of values that may have a positive probability of being sampled in this family of probability distributions.
    ///
    /// For example, `BernoulliDistribution.domain` is `[0, 1]` because 0 and 1 are the only values that can be sampled
    /// from a Bernoulli distribution, even though:
    /// - It is impossible to sample 1 from `BernoulliDistribution(probabilityOfOne: 0)`.
    /// - It is impossible to sample 0 from `BernoulliDistribution(probabilityOfOne: 1)`.
    ///
    /// > See also: ``support``
    static var domain: Set<Value> { get }
    
    /// The finite set of values that have a positive probability of being sampled from this specific probability distribution.
    var support: Set<Value> { get }
}
