//
//  Sum.swift
//  
//
//  Created by Lucca de Mello on 2023-05-10.
//

import Numerics

extension Collection where Element: AdditiveArithmetic {
    /// The sum of all the elements in the collection.
    /// - Returns: The sum.
    ///
    /// ## Example
    /// ```swift
    /// let sample: [Complex<Double>] = [42 + .i, Complex(.pi), -.i / 2]
    /// print(sample.sum()) // (45.1415926535898, 0.5)
    /// ```
    public func sum() -> Element {
        reduce(.zero, +)
    }
    
    // TODO: Consider adding any of the following as options:
    // - If Element is AlgebraicField: use RelaxedArithmetic.add from Swift Numerics.
    // - If Element is FloatingPoint: sort before summing for greater precision.
    // - If Element is BinaryInteger: cast to a higher-capacity type, sum, then cast back.
    //   This avoids integer overflows when the total sum does not overflow but the partial sums do overflow.
    // - If Element is BinaryFloatingPoint: cast to a higher-precision type, sum, then cast back.
}
