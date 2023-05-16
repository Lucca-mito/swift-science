//
//  Mean.swift
//  
//
//  Created by Lucca de Mello on 5/10/23.
//

import RealModule

extension Collection where Element: AlgebraicField & IntegerApproximable {
    /// The mean of this collection.
    /// - Precondition: The collection cannot be empty.
    public func mean() -> Element {
        precondition(!isEmpty)
        return sum() / Element(count)
    }
}

extension Collection where Element: BinaryInteger {
    /// The mean of this integer collection.
    /// - Returns: The mean as a `FloatingPoint` number.
    ///
    /// Swift can usually infer the floating-point type to be returned from context. If it can't, there are two things you can do:
    /// ```swift
    /// let sample: [Int]
    ///
    /// // Suppose you want to calculate the mean of `sample` to Double precision.
    ///
    /// // First solution:
    /// let mean: Double = sample.mean()
    ///
    /// // Second solution:
    /// let mean = sample.mean<Double>()
    /// ```
    public func mean<FloatingPointType: FloatingPoint>() -> FloatingPointType {
        FloatingPointType(sum()) / FloatingPointType(count)
    }
    // TODO: Once Swift support default generic arguments, make FloatingPointType be Double if it can't be inferred from context.
    // See https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md#default-generic-arguments
    //
    // One temporary solution (until default generic arguments are added) could be to add the following additional override:
    // public func mean() -> Double {
    //     Double(sum()) / Double(count)
    // }
}
