//
//  DistanceMeasurable.swift
//  
//
//  Created by Lucca de Mello on 5/13/23.
//

import ComplexModule

/// A type with a notion of distance between values.
///
/// Swift's `Strideable` protocol represents one-dimensional values with a distance function. This protocol is a more general version
/// of `Strideable` that allows values to have any number of dimensions. So ``MetricSpace`` includes not only every type
/// conforming to `Strideable`, but also multidimensional types such as `Complex`.
///
/// > See: For a theoretical introduction to metric spaces, see [metric space].
///
/// ## Example
/// ```swift
/// let z = Complex(1, 2)
/// print( z.distance(to: .i) == .sqrt(2) ) // true
/// print( z.squaredDistance(to: .i) ) // 2.0
/// ```
///
/// [metric space]:https://en.wikipedia.org/wiki/Metric_space
public protocol MetricSpace: Equatable {
    // TODO: Pitch adding this protocol to the standard library as a superprotocol of Strideable, possibly under a less technical name (e.g. DistanceMeasurable).
    
    /// A type that represents the distance between two values.
    associatedtype Stride: Comparable, SignedNumeric
    
    /// Returns the distance from this value to the given value.
    /// - Parameter other: The value to calculate the distance to.
    /// - Returns: The distance from this value to `other`.
    func distance(to other: Self) -> Stride
}

extension MetricSpace {
    func squaredDistance(to other: Self) -> Stride {
        let distance = distance(to: other)
        return distance * distance
    }
}

// Every type conforming to Strideable also conforms to MetricSpace.

extension Int: MetricSpace {}
extension Int8: MetricSpace {}
extension Int16: MetricSpace {}
extension Int32: MetricSpace {}
extension Int64: MetricSpace {}

extension UInt: MetricSpace {}
extension UInt8: MetricSpace {}
extension UInt16: MetricSpace {}
extension UInt32: MetricSpace {}
extension UInt64: MetricSpace {}

extension Float: MetricSpace {}
extension Double: MetricSpace {}

// TODO: Add Float16 and Float80

extension Complex: MetricSpace {
    public typealias Stride = RealType
    
    public func distance(to other: Self) -> RealType {
        (self - other).length
    }
    
    public func squaredDistance(to other: Self) -> RealType {
        (self - other).lengthSquared
    }
}

// When the Quaternion type of Swift Numerics is stabilized, conform it to MetricSpace as well.
