//
//  BoundedDistribution.swift
//  
//
//  Created by Lucca de Mello on 2023-04-22.
//

/// A probability distribution with a lower bound and an upper bound.
public protocol BoundedDistribution: LowerBoundedDistribution {
    /// The highest ``ProbabilityDistribution/Value`` with a positive probability.
    var max: Value { get }
}

extension BoundedDistribution where Value: AdditiveArithmetic {
    // While technically a statistic, the range has the same type as the distribution's domain.
    /// The difference between the distribution's maximum and its minimum.
    public var range: Value { max - min }
}
