//
//  BinaryReal.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

import Numerics

/// A binary real number with fixed-width significand
///
/// This type's conformance to `BinaryFloatingPoint` allows it to be initialized from a float literal. Moreover, the conformance of `RawSignificand` to `FixedWidthInteger` allows instances of ``Statistical`` to be randomly generated via `.random(in:)`. Neither of these features are available with the standard `Real`, making this type more useful for working with probability distributions.
public protocol Statistical: Real, BinaryFloatingPoint where RawSignificand: FixedWidthInteger {}

extension Double: Statistical {}
extension Float: Statistical {}

// TODO: Conform Float16 and Float80 to Statistical when I have a computer that has access to these types.
