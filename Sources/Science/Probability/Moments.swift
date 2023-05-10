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
    
    /// This distribution's [moment-generating function].
    ///
    /// [moment-generating function]:https://en.wikipedia.org/wiki/Moment-generating_function
    ///
    /// - Returns: The expected value of `.pow(.e, t * x)` where `x` follows this distribution.
    ///
    /// - Precondition: `t` ≥ 0
    /// - Note: `momentGeneratingFunction(0)` is always 1.
    func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic
}
