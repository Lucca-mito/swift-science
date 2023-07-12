//
//  DistributionWithMean.swift
//  
//
//  Created by Lucca de Mello on 2023-04-22.
//

/// A probability distribution that always has a mean.
public protocol DistributionWithMean: ProbabilityDistribution {
    /// The mean of the distribution.
    ///
    /// Also known as the *expectation* or the *first raw moment*.
    var mean: Statistic { get }
}
