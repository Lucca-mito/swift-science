//
//  DistributionWithVariance.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

/// A ``ProbabilityDistribution`` with a variance and a standard deviation.
///
/// Every probability ditribution with a *p*th [moment] has a *(p+1)* th moment. As a consequence, every ``DistributionWithVariance`` is also a ``DistributionWithMean``. However, some probability distributions have a mean but don't have a variance.
///
/// [moment]:https://en.wikipedia.org/wiki/Moment_(mathematics)#Notable_moments
public protocol DistributionWithVariance: DistributionWithMean {
    var variance: Statistic { get }
}

extension DistributionWithVariance {
    var standardDeviation: Statistic { .sqrt(variance) }
}
