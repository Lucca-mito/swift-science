//
//  mean.swift
//  
//
//  Created by Lucca de Mello on 5/10/23.
//

import Numerics

extension Collection where Element: AlgebraicField {
    /// The mean of this collection, if it can be approximated.
    public func mean() -> Element? {
        if let count = Element(exactly: count) {
            return sum() / count
        } else {
            return nil
        }
    }
}

extension Collection where Element: FloatingPoint {
    /// The mean of this collection.
    public func mean() -> Element {
        sum() / Element(count)
    }
}

extension Collection where Element: BinaryInteger {
    /// The mean of this integer collection.
    /// - Returns: The mean as a `FloatingPoint` number.
    ///
    /// Swift can usually infer the floating-point type to be returned from context. If it can't, there are two things you can do:
    /// ```swift
    /// let sample = [1, 2, 3]
    /// // Suppose you want to calculate the mean to Double precision.
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

// Swift does not currently support parameterized extensions, but it (probably) eventually will
// since this feature is proposed in the Generics Manifesto:
// https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md#parameterized-extensions
//
// Once Swift support parametrized extensions, uncomment the following extension:
//
// extension<RealType: Real> Collection where Element == Complex<RealType> {
//     public func mean() -> Element {
//         sum() / Element(count)
//     }
// }
