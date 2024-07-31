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
    /// - Parameter precision: The precision to which the mean should be computed. If omitted, defaults to `Double` precision.
    /// - Returns: The mean as a `FloatingPoint` number.
    /// - Precondition: The collection cannot be empty.
    public func mean<FloatingPointType: FloatingPoint>(
        toPrecision precision: FloatingPointType.Type = Double.self
    ) -> FloatingPointType
    {
        precondition(!isEmpty)
        return FloatingPointType(sum()) / FloatingPointType(count)
    }
}
