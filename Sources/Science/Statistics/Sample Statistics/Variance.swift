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
        squaredDeviationsFromMean().sum() / Element.Stride(denominator)
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

// MARK: Variance of an integer collection.
// Just convert the integers to a FloatingPoint type and use the variance functions above.

extension Collection where Element: BinaryInteger {
    /// The population variance of the integer collection, computed to the specified `FloatingPoint` precision.
    /// - Parameter precision: The precision to which the variance should be computed. If omitted, defaults to `Double.self`.
    /// - Returns: The population variance as a `FloatingPoint` number.
    /// - Precondition: The collection cannot be empty.
    public func populationVariance<FloatingPointType>(
        toPrecision precision: FloatingPointType.Type = Double.self
    ) -> FloatingPointType
    where
        FloatingPointType: FloatingPoint & AlgebraicField & IntegerApproximable & Euclidean,
    
        // The requested precision is FloatingPointType, but the expression in the return statement 
        // has type FloatingPointType.Stride. This constraint eliminates the mismatch.
        FloatingPointType.Stride == FloatingPointType
    {
        precondition(!isEmpty)
        return map(FloatingPointType.init).populationVariance()
    }
    
    /// The sample variance of the integer collection.
    /// - Returns: The sample variance as a `FloatingPoint` number.
    /// - Parameter precision: The precision to which the variance should be computed. If omitted, defaults to `Double.self`.
    /// - Precondition: There must be at least 2 elements in the collection.
    public func sampleVariance<FloatingPointType>(
        toPrecision precision: FloatingPointType.Type = Double.self
    ) -> FloatingPointType
    where
        FloatingPointType: FloatingPoint & AlgebraicField & IntegerApproximable & Euclidean,
        FloatingPointType.Stride == FloatingPointType
    {
        precondition(count > 1)
        return map(FloatingPointType.init).sampleVariance()
    }
}
