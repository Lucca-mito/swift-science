//
//  BinaryReal.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

import Numerics

/// A real number with a binary, floating-point, fixed-width encoding.
///
/// This type's conformance to `BinaryFloatingPoint` allows it to be initialized with a float literal. Moreover, the conformance of `RawSignificand` to `FixedWidthInteger` allows instances of ``BinaryReal`` to be randomly generated via `.random(in:)`. Neither of these features are available with the standard `Real`, making this type more useful for working with probability distributions.
public protocol BinaryReal: Real, BinaryFloatingPoint where RawSignificand: FixedWidthInteger {}

extension Double: BinaryReal {}
extension Float: BinaryReal {}
