//
//  SquaredDeviations.swift
//  
//
//  Created by Lucca de Mello on 5/16/23.
//

import RealModule

extension Collection where Element: AlgebraicField & IntegerApproximable & Euclidean {
    /// The squared distances from each element in this collection to their mean.
    ///
    /// - Returns: The squared ``Euclidean`` distance between each element and the mean of this collection.
    ///
    /// > See: [Squared deviations from the mean].
    ///
    /// [Squared deviations from the mean]: https://en.wikipedia.org/wiki/Squared_deviations_from_the_mean
    public func squaredDeviations() -> [Element.Stride] {
        // The squared deviations are undefined for an empty collection since it has no mean, but
        // let's accept an empty collection anyway (instead of trapping with a `precondition`) to
        // follow Postel's law.
        guard !isEmpty else { return [] }
        
        let mean = mean()
        return map { element in Element.squaredDistance(between: element, and: mean) }
    }
}
