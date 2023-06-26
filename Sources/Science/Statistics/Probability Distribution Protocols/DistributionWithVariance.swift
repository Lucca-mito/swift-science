//
//  DistributionWithVariance.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

import RealModule

/// A probability distribution that always has a variance and a standard deviation.
///
/// Every probability distribution with a *p*th [moment] has a *(p+1)* th moment. As a consequence, every
/// `DistributionWithVariance` is also a ``DistributionWithMean``.
/// However, the converse is not true: some probability distributions have a mean but don't have a variance.
///
/// [moment]:https://en.wikipedia.org/wiki/Moment_(mathematics)#Notable_moments
public protocol DistributionWithVariance: DistributionWithMean {
    /// The variance of the distribution.
    ///
    /// Also known as the second central moment.
    var variance: Statistic { get }
    
    var standardDeviation: Statistic { get }
}

extension DistributionWithVariance {
    // A default implementation of the standard deviation.
    // Some distributions, such as the NormalDistribution, may instead opt to implement
    // standardDeviation as a stored property.
    public var standardDeviation: Statistic { .sqrt(variance) }
}
