//
//  Complex+Euclidean.swift
//  
//
//  Created by Lucca de Mello on 5/15/23.
//

import ComplexModule

extension Complex: Euclidean {
    public typealias Stride = RealType
    
    public static func distance(between lhs: Self, and rhs: Self) -> RealType {
        (rhs - lhs).length
    }
    
    // Euclidean provides a default implementation of squaredDistance. I'd like to override it with
    // the following definition, which is more efficient.
    //
    // public static func squaredDistance(between lhs: Self, and rhs: Self) -> RealType {
    //     (rhs - lhs).lengthSquared
    // }
    //
    // But this result in two definitions coexisting in the documentation, even though only the
    // override actually exists. TODO: Fix this.
}

// When the Quaternion type of Swift Numerics is stabilized, conform it to Euclidean as well.
