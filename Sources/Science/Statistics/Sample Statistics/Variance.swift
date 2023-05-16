//
//  Variance.swift
//  
//
//  Created by Lucca de Mello on 5/12/23.
//

import RealModule

extension Collection where Element: AlgebraicField & IntegerApproximable & Euclidean {
    /// The squared distances from each element in this collection to their mean.
    /// - Precondition: The mean must exist, so the collection cannot be empty.
    ///
    /// > See: https://en.wikipedia.org/wiki/Squared_deviations_from_the_mean
    ///
    /// The precondition is not checked in this method because this method is not part of the public API, at least for now.
    /// Instead, the precondition is checked in the public methods that call this method.
    private func _squaredDeviations() -> [Element.Stride] {
        let mean = mean()
        return map { element in Element.squaredDistance(between: element, and: mean) }
    }
}

extension Collection
where
    Element: AlgebraicField & IntegerApproximable & Euclidean,
    Element.Stride: AlgebraicField & IntegerApproximable
{
    private func _variance(denominator: Int) -> Element.Stride {
        _squaredDeviations().sum() / Element.Stride(denominator)
    }
    
    /// The population variance of this collection.
    /// - Returns: The population variance, ¹⁄ₙ ∑ₓ ‖x - 𝜇‖² where ‖x - 𝜇‖ is the ``Euclidean`` distance from each element x to the sample mean 𝜇.
    /// - Precondition: The collection cannot be empty.
    public func populationVariance() -> Element.Stride {
        precondition(!isEmpty)
        return _variance(denominator: count)
    }
    
    /// The sample variance of this collection.
    /// - Precondition: There must be at least 2 elements in the collection.
    public func sampleVariance() -> Element.Stride {
        precondition(count > 1)
        return _variance(denominator: count - 1)
    }
}

extension Collection where Element: BinaryInteger {
    /// The population variance of this integer collection.
    /// - Returns: The population variance as a `FloatingPoint` number.
    /// - Precondition: The collection cannot be empty.
    public func populationVariance<FloatingPointType>() -> FloatingPointType
    where
        // This long list of requirements on FloatingPointType is only necessary because
        // AlgebraicField, IntegerApproximable, and Euclidean are third-party protocols:
        // - AlgebraicField is from Swift Numerics.
        // - IntegerApproximable and Euclidean are from this package, Swift Science.
        // If these protocols were instead in the standard library, FloatingPoint would inherit
        // from them and we would be able to write this as just FloatingPointType: FloatingPoint.
        FloatingPointType: FloatingPoint & AlgebraicField & IntegerApproximable & Euclidean,
    
        // But the additional requirement that FloatingPointType.Stride == FloatingPointType is
        // necessary regardless. If a user calls this method passing (say) Double as the type
        // argument, they expect the method to return a Double. That said, all FloatingPoint types
        // in the standard library have a Stride of Self, so this additional requirement shouldn't
        // be an issue.
        FloatingPointType.Stride == FloatingPointType
    {
        precondition(!isEmpty)
        return map(FloatingPointType.init).populationVariance()
    }
    
    /// The sample variance of this integer collection.
    /// - Returns: The sample variance as a `FloatingPoint` number.
    /// - Precondition: There must be at least 2 elements in the collection.
    public func sampleVariance<FloatingPointType>() -> FloatingPointType
    where
        FloatingPointType: FloatingPoint & AlgebraicField & IntegerApproximable & Euclidean,
        FloatingPointType.Stride == FloatingPointType
    {
        precondition(count > 1)
        return map(FloatingPointType.init).sampleVariance()
    }
}
