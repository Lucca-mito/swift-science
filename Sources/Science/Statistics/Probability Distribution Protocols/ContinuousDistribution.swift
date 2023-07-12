//
//  ContinuousDistribution.swift
//
//
//  Created by Lucca de Mello on 2023-04-15.
//

/// A [continuous probability distribution].
///
/// [continuous probability distribution]:https://en.wikipedia.org/wiki/Probability_distribution#Absolutely_continuous_probability_distribution
public protocol ContinuousDistribution: ProbabilityDistribution where Value == Statistic {
    func probabilityDensity(at value: Value) -> Statistic
}

extension ContinuousDistribution {
    public func probability(ofExactly value: Value) -> Statistic { 0 }
}
