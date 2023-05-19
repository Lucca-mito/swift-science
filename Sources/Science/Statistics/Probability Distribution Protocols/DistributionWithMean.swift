//
//  DistributionWithMean.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

/// A probability distribution with a mean.
public protocol DistributionWithMean: ProbabilityDistribution {
    /// The mean of the distribution.
    ///
    /// Also known as the *expectation* or the *first raw moment*.
    var mean: Statistic { get }
}
