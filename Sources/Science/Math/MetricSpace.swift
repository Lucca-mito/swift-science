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
/// > See: [Metric space] for a theoretical introduction to metric spaces.
///
/// ## Example
/// ```swift
/// let z = Complex(1, 2)
/// print( z.distance(to: .i) == .sqrt(2) ) // true
/// print( z.squaredDistance(to: .i) ) // 2.0
/// ```
///
/// [Metric space]:https://en.wikipedia.org/wiki/Metric_space
public protocol MetricSpace: Equatable {
    // TODO: Pitch adding this protocol to the standard library as a superprotocol of Strideable, possibly under a less technical name (e.g. DistanceMeasurable).
    
    /// A type that represents the distance between two values.
    associatedtype Stride: Comparable, SignedNumeric
    
    /// Returns the distance from this value to the given value, expressed as a ``Stride``.
    /// - Parameter other: The value to calculate the distance to.
    /// - Returns: The distance from this value to `other`.
    ///
    /// This function must satisfy the four [metric space] laws:
    /// 1. The distance from a point to itself is zero.
    /// ```swift
    /// x.distance(to: x) == .zero
    /// ```
    /// 2. The distance between two distinct points is always positive.
    /// ```swift
    /// // x != y
    /// x.distance(to: y) > .zero
    /// ```
    /// 3. The distance from *x* to *y* is always the same as the distance from *y* to *x*.
    /// ```swift
    /// x.distance(to: y) == y.distance(to: x)
    /// ```
    /// 4. The [triangle inequality] holds:
    /// ```swift
    /// x.distance(to: z) <= x.distance(to: y) + y.distance(to: z)
    /// ```
    ///
    /// [metric space]:https://en.wikipedia.org/wiki/Metric_space
    /// [triangle inequality]:https://en.wikipedia.org/wiki/Triangle_inequality
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

// TODO: Add Float16 and Float80 conformances with the appropriate availability checks.

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

// TODO: Pointer types should also conform to MetricSpace since they conform to Stridable.
