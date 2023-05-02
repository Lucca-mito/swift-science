//
//  Samplable.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

/// A probability distribution that can be randomly sampled.
///
/// Conforming types only have to implement the ``sample()`` method.
///
/// All probability distributions conforming to ``ClosedFormQuantile`` automatically get a ``sample()`` implementation using [inverse transform sampling] when ``ProbabilityDistribution/Statistic`` can be randomly generated.
///
/// Distributions that do not have a closed-form quantile can instead conform to ``Samplable`` directly with a custom sampling function.
/// For an example, ``NormalDistribution`` conforms to ``Samplable`` using the Box–Muller transform.
///
/// [inverse transform sampling]:https://en.wikipedia.org/wiki/Inverse_transform_sampling
public protocol Samplable: ProbabilityDistribution {
    /// Generates one random sample from this probability distribution.
    func sample() -> Value
}

extension Samplable {
    /// Generates `count` random samples from this probability distribution.
    public func sample(count: some FixedWidthInteger) -> [Value] {
        (1...count).map { _ in sample() }
    }
}
