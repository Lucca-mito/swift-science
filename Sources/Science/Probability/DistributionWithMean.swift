//
//  DistributionWithMean.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

/// A probability distribution with a mean.
public protocol DistributionWithMean: ProbabilityDistribution {
    var mean: Statistic { get }
}
