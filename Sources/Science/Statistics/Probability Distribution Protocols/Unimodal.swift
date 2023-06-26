//
//  Unimodal.swift
//  
//
//  Created by Lucca de Mello on 2023-06-25.
//

/// A probability distribution that always has a single mode.
///
/// For example, ``NormalDistribution`` conforms to `Unimodal` because its ``mode`` is always its
/// ``NormalDistribution/mean``. In contrast, ``BernoulliDistribution`` does not conform to `Unimodal` because,
/// although the mode of a Bernoulli distribution is almost always unique, the mode is not unique when the Bernoulli distribution is
/// ``BernoulliDistribution/fair``.
public protocol Unimodal: FiniteModal {
    /// The unique ``ProbabilityDistribution/Value`` that is the most likely to be sampled from the distribution.
    var mode: Value { get }
}

extension Unimodal {
    public var modes: Set<Value> { [mode] }
}
