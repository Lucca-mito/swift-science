//
//  Moments.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

/// A probability distribution for which all [moments] are defined.
///
/// [moments]:https://en.wikipedia.org/wiki/Moment_(mathematics)
public protocol Moments: DistributionWithVariance {
    func momentGeneratingFunction(_ t: Int) -> Statistic
    
    /// The skewness of this distribution.
    ///
    /// Also known as the third standardized moment.
    var skewness: Statistic { get }
    
    // TODO: Add kurtosis.
}
