//
//  DistributionWithMoments.swift
//  
//
//  Created by Lucca de Mello on 2023-04-22.
//

/// A probability distribution for which all [moments] are always defined.
///
/// [moments]:https://en.wikipedia.org/wiki/Moment_(mathematics)
public protocol DistributionWithMoments: DistributionWithVariance {
    /// The skewness of the distribution.
    ///
    /// Also known as the third standardized moment.
    var skewness: Statistic { get }
    
    // TODO: Add kurtosis.
    
    /// The distribution's [moment-generating function].
    ///
    /// [moment-generating function]:https://en.wikipedia.org/wiki/Moment-generating_function
    ///
    /// - Returns: The expected value of
    /// ![e to the power of X t](exp(Xt))
    /// where 𝑋 is a random variable following the distribution.
    ///
    /// ## Usage notes
    /// - Precondition: `t` ≥ 0
    ///
    /// `momentGeneratingFunction(0)` is always 1.
    ///
    /// ## Example
    /// ```swift
    /// let normal = NormalDistribution<Double>.standard
    /// print( normal.momentGeneratingFunction(1) ) // Approximately 1.64872
    /// print( normal.sample(count: 1_000_000).map(Double.exp).mean() ) // Approximately 1.64872
    /// ```
    ///
    /// ## Discussion
    /// The moment-generating function is commonly abbreviated as MGF.
    /// Every probability distribution that has an MGF has a _unique_ MGF.
    func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic
}
