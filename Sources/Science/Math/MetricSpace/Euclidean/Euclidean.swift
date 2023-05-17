//
//  Euclidean.swift
//  
//
//  Created by Lucca de Mello on 5/15/23.
//

import ComplexModule

/// A type whose distance between values is the length of a line segment between them.
///
/// ## Conforming to the Euclidean protocol
/// Types conforming to `Euclidean` must implement a ``MetricSpace/distance(between:and:)-3rp36`` function that
/// is equivalent to the [Euclidean distance] function.
///
/// `Euclidean` also defines a ``squaredDistance(between:and:)-4px6m`` function with a default implementation that
/// simply squares the result of  ``MetricSpace/distance(between:and:)-3rp36``. Conforming types are encouraged to
/// override this implementation if they have a better one, such as a implementation that is more numerically stable.
///
/// [Euclidean distance]: https://en.wikipedia.org/wiki/Euclidean_distance
public protocol Euclidean: MetricSpace {
    /// The square of the distance between two values.
    /// - Returns: The [squared Euclidean distance] between `'lhs` and `rhs`.
    ///
    /// This function is used to define the population variance and the sample variance, but it's also useful by itself. For example, the
    /// squared Euclidean distance is used in the method of [least squares].
    ///
    /// [squared Euclidean distance]: https://en.wikipedia.org/wiki/Euclidean_distance#Squared_Euclidean_distance
    /// [least squares]: https://en.wikipedia.org/wiki/Least_squares
    static func squaredDistance(between lhs: Self, and rhs: Self) -> Stride
}

extension Euclidean {
    public static func squaredDistance(between lhs: Self, and rhs: Self) -> Stride {
        let distance = distance(between: lhs, and: rhs)
        return distance * distance
    }
}
