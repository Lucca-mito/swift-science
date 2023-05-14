//
//  Variance.swift
//  
//
//  Created by Lucca de Mello on 5/12/23.
//

import RealModule

extension Collection where Element: MetricSpace & AlgebraicField {
    /// The squared distances from each element in this collection to their mean.
    ///
    /// https://en.wikipedia.org/wiki/Squared_deviations_from_the_mean
    private func _squaredDeviations() -> [Element.Stride]? {
        guard let mean = mean() else {
            return nil
        }
        
        return map { element in element.squaredDistance(to: mean) }
    }
}

extension Collection where Element: MetricSpace & AlgebraicField, Element.Stride: AlgebraicField {
    private func _variance(denominator: Int) -> Element.Stride? {
        guard let numerator = _squaredDeviations()?.sum(),
              let denominator = Element.Stride(exactly: denominator),
              denominator > 0
        else {
            return nil
        }
        
        return numerator / denominator
    }
    
    public func populationVariance() -> Element.Stride? {
        _variance(denominator: count)
    }
    
    public func sampleVariance() -> Element.Stride? {
        _variance(denominator: count - 1)
    }
}
