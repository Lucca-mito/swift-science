//
//  Variance.swift
//  
//
//  Created by Lucca de Mello on 2023-05-12.
//

import RealModule

extension Collection
where
    // The `Element`s themselves must be `AlgebraicField` because their mean must exist.
    Element: AlgebraicField & IntegerApproximable & Euclidean,

    // And their `Stride` must be `AlgebraicField` so we can average the squared deviations to the mean.
    Element.Stride: AlgebraicField & IntegerApproximable
{
    /// Helper function for the population and sample variances.
    /// - Parameter denominator: Either `count` (for population variance) or `count - 1` (for sample variance).
    /// - Returns: The total squared deviation divided by `denominator`.
    private func _variance(denominator: Int) -> Element.Stride {
        squaredDeviations().sum() / Element.Stride(denominator)
    }
    
    /// The population variance of the collection.
    ///
    /// - Returns: The population variance:
    /// ![Squared norm of x_i minus mu. Summed from i = 1 to n. Everything divided by n.](population-variance)
    /// where 𝑛 is the collection's `count` and ‖𝑥ᵢ - 𝜇‖ is the ``Euclidean`` distance from each element 𝑥ᵢ to the population mean 𝜇.
    ///
    /// - Precondition: The collection cannot be empty.
    public func populationVariance() -> Element.Stride {
        precondition(!isEmpty)
        return _variance(denominator: count)
    }
    
    /// The sample variance of the collection.
    ///
    /// - Returns: The sample variance:
    /// ![Sum, from i = 1 to n, of the squared norm of x_i minus mu. Everything divided by n minus 1.](sample-variance)
    /// where 𝑛 is the collection's `count` and ‖𝑥ᵢ - 𝜇‖ is the ``Euclidean`` distance from each element 𝑥ᵢ to the sample mean 𝜇.
    ///
    /// - Precondition: There must be at least 2 elements in the collection.
    ///
    /// The sample variance is similar to the population variance, but with *n* - 1 in the denominator instead of *n* (where *n* is the
    /// size of the collection). As a result,
    /// 1. The sample variance is always slightly greater than the population variance.
    /// 2. The sample variance better estimates the variance of the population (or the ``ProbabilityDistribution``) from
    /// which the values were sampled.
    ///
    /// > See: [Population variance and sample variance].
    ///
    /// [Population variance and sample variance]: https://en.wikipedia.org/wiki/Variance#Population_variance_and_sample_variance
    public func sampleVariance() -> Element.Stride {
        precondition(count > 1)
        return _variance(denominator: count - 1)
    }
}

extension Collection where Element: BinaryInteger {
    /// The population variance of the integer collection, computed to the specified `FloatingPoint` precision.
    /// - Returns: The population variance as a `FloatingPoint` number.
    /// - Precondition: The collection cannot be empty.
    ///
    /// The variance of an integer collection is not necessarily an integer, so it must be computed to some floating-point precision.
    /// There are two ways you can specify the desired precision:
    /// ```swift
    /// let population: [Int]
    ///
    /// // Suppose you want to calculate the variance of `population` to Double precision.
    ///
    /// // First solution: specify the desired return type.
    /// let variance: Double = population.populationVariance()
    ///
    /// // Second solution: specify the type argument.
    /// let variance = population.populationVariance<Double>()
    /// ```
    /// Both solutions are equivalent; which one you should choose is a matter of style preference.
    public func populationVariance<FloatingPointType>() -> FloatingPointType
    where
        FloatingPointType: FloatingPoint & AlgebraicField & IntegerApproximable & Euclidean,
    
        // The expression in the return statement has type FloatingPointType.Stride. So the
        // additional constraint `FloatingPointType.Stride == FloatingPointType` allows us to write
        // the return type of populationVariance as FloatingPointType. This makes populationVariance
        // easier to understand: if I call it passing Double as the FloatingPointType, the
        // population variance of the integer collection will be returned in Double precision.
        FloatingPointType.Stride == FloatingPointType
    {
        precondition(!isEmpty)
        return map(FloatingPointType.init).populationVariance()
    }
    
    /// The sample variance of the integer collection.
    /// - Returns: The sample variance as a `FloatingPoint` number.
    /// - Precondition: There must be at least 2 elements in the collection.
    ///
    /// The variance of an integer collection is not necessarily an integer, so it must be computed to some floating-point precision.
    /// There are two ways you can specify the desired precision:
    /// ```swift
    /// let sample: [Int]
    ///
    /// // Suppose you want to calculate the variance of `sample` to Double precision.
    ///
    /// // First solution: specify the desired return type.
    /// let variance: Double = sample.sampleVariance()
    ///
    /// // Second solution: specify the type argument.
    /// let variance = sample.sampleVariance<Double>()
    /// ```
    /// Both solutions are equivalent; which one you should choose is a matter of style preference.
    public func sampleVariance<FloatingPointType>() -> FloatingPointType
    where
        FloatingPointType: FloatingPoint & AlgebraicField & IntegerApproximable & Euclidean,
    
        // See the comment in populationVariance.
        FloatingPointType.Stride == FloatingPointType
    {
        precondition(count > 1)
        return map(FloatingPointType.init).sampleVariance()
    }
}
