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
    /// - Parameter t: Which raw moment to compute.
    /// - Returns: The `t`th raw moment of this distribution.
    ///
    /// Mathematically, if `dist` is an instance of a probability distribution conforming to ``Moments`` then
    /// `dist.momentGeneratingFunction(t)` is 𝔼[𝑋ᵗ] where 𝑋 ~ `dist`.
    ///
    /// - Precondition: `t` ≥ 0
    /// - Note: `dist.momentGeneratingFunction(0)` is always 1.
    ///
    /// ## Examples
    /// - `dist.momentGeneratingFunction(1)` is 𝔼[𝑋]: the distribution's ``DistributionWithMean/mean``.
    /// - `dist.momentGeneratingFunction(2) - .pow(dist.mean, 2)` is 𝔼[𝑋²] - 𝔼[𝑋]²: the distribution's
    ///   ``DistributionWithVariance/variance``.
    func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic
}
