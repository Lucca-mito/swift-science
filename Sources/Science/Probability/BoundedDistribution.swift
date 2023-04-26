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
