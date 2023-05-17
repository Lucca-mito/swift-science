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
/// of `Strideable` that allows values to have any number of dimensions. So `MetricSpace` includes not only every type
/// conforming to `Strideable`, but also multidimensional types such as `Complex`.
///
/// > See: [Metric space] for a theoretical introduction to metric spaces.
///
/// ## Example
/// ```swift
/// <#TODO#>
/// ```
///
/// [Metric space]: https://en.wikipedia.org/wiki/Metric_space
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
    /// .distance(between: x, and: x) == .zero
    /// ```
    /// 2. The distance between two distinct points is always positive.
    /// ```swift
    /// // x != y
    /// .distance(between: x, and: y) > .zero
    /// ```
    /// 3. The distance from *x* to *y* is always the same as the distance from *y* to *x*.
    /// ```swift
    /// .distance(between: x, and: y) == .distance(between: y, and: x)
    /// ```
    /// 4. The [triangle inequality] holds:
    /// ```swift
    /// .distance(between: x, and: z) <= .distance(between: x, and: y) + .distance(between: y, and: z)
    /// ```
    ///
    /// [metric space]: https://en.wikipedia.org/wiki/Metric_space
    /// [triangle inequality]: https://en.wikipedia.org/wiki/Triangle_inequality
    static func distance(between lhs: Self, and rhs: Self) -> Stride
}
