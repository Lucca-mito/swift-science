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
    public func mean() -> Element {
        precondition(!isEmpty)
        return sum() / Element(count)
    }
}

extension Collection where Element: BinaryInteger {
    /// The arithmetic mean of the integer collection.
    /// - Returns: The mean as a `FloatingPoint` number.
    ///
    /// Swift can usually infer from the surrounding context which `FloatingPoint` type, like `Double` or `Float`, should be
    /// returned. But when Swift is unable to infer the return type — that is, if you get a compiler error trying to use this function —
    /// there are two things you can do to fix this:
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
    /// Both solutions are equivalent; which one you should choose is a matter of style preference.
    public func mean<FloatingPointType: FloatingPoint>() -> FloatingPointType {
        FloatingPointType(sum()) / FloatingPointType(count)
    }
    // TODO: Once Swift support default generic arguments, make FloatingPointType be Double if it can't be inferred from context.
    // See https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md#default-generic-arguments
    //
    // One temporary solution (until default generic arguments are added) could be to add the following overload:
    // public func mean() -> Double {
    //     Double(sum()) / Double(count)
    // }
}
