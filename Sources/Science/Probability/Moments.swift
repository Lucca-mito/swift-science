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
    /// The skewness of this distribution.
    ///
    /// Also known as the third standardized moment.
    var skewness: Statistic { get }
    
    // TODO: Add kurtosis.
    
    /// This distribution's [moment-generating function][wiki].
    ///
    /// For any integer `t` ≥ 0, `momentGeneratingFunction(t)` returns the `t`th raw moment of the distribution.
    /// In particular, `momentGeneratingFunction(1)` is the distribution's ``DistributionWithMean/mean``.
    ///
    /// [wiki]:https://en.wikipedia.org/wiki/Moment-generating_function
    func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic
}
