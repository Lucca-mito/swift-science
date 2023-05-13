//
//  BoundedDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

/// A probability distribution with a lower bound and an upper bound.
public protocol BoundedDistribution: ProbabilityDistribution {
    /// The lowest ``ProbabilityDistribution/Value`` with a positive probability.
    var min: Value { get }
    
    /// The highest ``ProbabilityDistribution/Value`` with a positive probability.
    var max: Value { get }
}

extension BoundedDistribution where Value: AdditiveArithmetic {
    // While technically a statistic, the range has the same type as the distribution's domain.
    /// The difference between the distribution's maximum and its minimum.
    public var range: Value { max - min }
}
