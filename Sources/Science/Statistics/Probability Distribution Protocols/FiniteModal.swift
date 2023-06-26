//
//  FiniteModal.swift
//  
//
//  Created by Lucca de Mello on 2023-06-25.
//

/// A probability distribution with a finite set of modes.
public protocol FiniteModal: ProbabilityDistribution where Value: Hashable {
    /// The set of values that are the most likely to be sampled from the probability distribution.
    ///
    /// ## Example
    /// ```swift
    /// let eventsPerMinute = PoissonDistribution(rate: 3)
    /// print(eventsPerMinute.modes) // [2, 3]
    ///
    /// let fairCoin = BernoulliDistribution.fair
    /// print(fairCoin.modes) // [0, 1]
    /// ```
    var modes: Set<Value> { get }
}
