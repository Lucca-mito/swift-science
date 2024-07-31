//
//  MetricSpace.swift
//  
//
//  Created by Lucca de Mello on 2023-05-13.
//

import ComplexModule

/// A type with a notion of distance between values.
///
/// This is similar to Swift's `Strideable` protocol, which represents one-dimensional values with a distance function. This protocol
/// is a more general version of `Strideable`, allowing values to have any number of dimensions. So `MetricSpace` includes not 
/// only every type conforming to `Strideable`, such as built-in numeric types, but also multidimensional types such as `Complex`.
///
/// > See: [Metric space] for a theoretical introduction to metric spaces.
///
/// ## Example
/// ```swift
/// let distance: Double = Complex.distance(between: .i, and: 1)
/// print(distance == .sqrt(2)) // true
/// ```
///
/// [Metric space]: https://en.wikipedia.org/wiki/Metric_space
public protocol MetricSpace: Equatable {
    /// A type that represents the distance between two values.
    associatedtype Stride: Comparable, SignedNumeric
    
    /// Returns the distance between two values, expressed as a ``Stride``.
    /// - Returns: The distance between `lhs` and `rhs`.
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
