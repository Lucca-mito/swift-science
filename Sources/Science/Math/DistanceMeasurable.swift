//
//  DistanceMeasurable.swift
//  
//
//  Created by Lucca de Mello on 5/13/23.
//

import ComplexModule

/// A type with a notion of distance between values.
///
/// Mathematically, this corresponds to a [metric space].
///
/// [metric space][https://en.wikipedia.org/wiki/Metric_space]
public protocol DistanceMeasurable {
    /// A type that represents the distance between two values.
    associatedtype Stride: Comparable, SignedNumeric
    
    /// Returns the distance from this value to the given value.
    /// - Parameter other: The value to calculate the distance to.
    /// - Returns: The distance from this value to `other`.
    func distance(to other: Self) -> Stride
}

extension DistanceMeasurable {
    func squaredDistance(to other: Self) -> Stride {
        let distance = distance(to: other)
        return distance * distance
    }
}

extension Int: DistanceMeasurable {}
extension Int8: DistanceMeasurable {}
extension Int16: DistanceMeasurable {}
extension Int32: DistanceMeasurable {}
extension Int64: DistanceMeasurable {}

extension UInt: DistanceMeasurable {}
extension UInt8: DistanceMeasurable {}
extension UInt16: DistanceMeasurable {}
extension UInt32: DistanceMeasurable {}
extension UInt64: DistanceMeasurable {}

extension Float: DistanceMeasurable {}
extension Double: DistanceMeasurable {}

// TODO: Add Float16 and Float80

extension Complex: DistanceMeasurable {
    public typealias Stride = RealType
    
    public func distance(to other: Self) -> RealType {
        (self - other).length
    }
    
    public func squaredDistance(to other: Self) -> RealType {
        (self - other).lengthSquared
    }
}
