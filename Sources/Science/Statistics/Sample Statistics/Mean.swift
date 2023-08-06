//
//  Mean.swift
//  
//
//  Created by Lucca de Mello on 2023-10-05.
//

import RealModule

extension Collection where Element: AlgebraicField & IntegerApproximable {
    /// The arithmetic mean of the collection.
    /// - Precondition: The collection cannot be empty.
    /// - Returns: The mean.
    public func mean() -> Element {
        precondition(!isEmpty)
        return sum() / Element(count)
    }
}

extension Collection where Element: BinaryInteger {
    /// The arithmetic mean of the integer collection, computed to the specified `FloatingPoint` precision.
    /// - Returns: The mean as a `FloatingPoint` number.
    /// - Precondition: The collection cannot be empty.
    ///
    /// The mean of an integer collection is not necessarily an integer, so it must be computed to some floating-point precision.
    /// There are two ways you can specify the desired precision:
    /// ```swift
    /// let data: [Int]
    ///
    /// // Suppose you want to calculate the mean of `data` to Double precision.
    ///
    /// // First solution: specify the desired return type.
    /// let mean: Double = data.mean()
    ///
    /// // Second solution: specify the type argument.
    /// let mean = data.mean<Double>()
    /// ```
    /// Both solutions are equivalent; which one you should choose is a matter of style preference.
    public func mean<FloatingPointType: FloatingPoint>() -> FloatingPointType {
        precondition(!isEmpty)
        return FloatingPointType(sum()) / FloatingPointType(count)
    }
    // TODO: Once Swift support default generic arguments, make FloatingPointType be Double if it can't be inferred from context.
    // See https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md#default-generic-arguments
    //
    // One temporary solution (until default generic arguments are added) could be to add the following overload:
    // public func mean() -> Double {
    //     Double(sum()) / Double(count)
    // }
}
