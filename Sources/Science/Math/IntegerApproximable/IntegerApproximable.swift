//
//  IntegerApproximable.swift
//  
//
//  Created by Lucca de Mello on 2023-05-15.
//

/// A numeric type that can be approximated from an integer.
public protocol IntegerApproximable: Numeric {
    /// Creates a new value, rounded to the closest possible representation.
    /// - Parameter value: The integer to be approximated.
    init(_ value: some BinaryInteger)
}
