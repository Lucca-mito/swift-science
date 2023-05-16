//
//  Euclidean.swift
//  
//
//  Created by Lucca de Mello on 5/15/23.
//

import ComplexModule

public protocol Euclidean: MetricSpace {
    static func squaredDistance(between lhs: Self, and rhs: Self) -> Stride
}

extension Euclidean {
    public static func squaredDistance(between lhs: Self, and rhs: Self) -> Stride {
        let distance = distance(between: lhs, and: rhs)
        return distance * distance
    }
}
