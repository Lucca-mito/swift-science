//
//  sum.swift
//  
//
//  Created by Lucca de Mello on 5/10/23.
//

import Numerics

extension Collection where Element: AdditiveArithmetic {
    // TODO: Consider, either by default or as an option, any of the following:
    // - If Element is AlgebraicField: use RelaxedArithmetic.add from Swift Numerics.
    // - If Element is FloatingPoint: sort before summing for greater precision.
    // - If Element is BinaryInteger: cast to a higher-capacity type, sum, then cast back.
    //   This avoids integer overflows when the total sum does not overflow but the partial sums do overflow.
    // - If Element is BinaryFloatingPoint: cast to a higher-precision type, sum, then cast back.
    public func sum() -> Element {
        reduce(into: .zero, +=) // More efficient version of reduce(.zero, +)
    }
}
