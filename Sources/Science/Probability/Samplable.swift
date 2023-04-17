//
//  Samplable.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

/// A probability distribution that can be randomly sampled.
///
/// All probability distributions conforming to ``ClosedFormQuantile`` automatically conform to ``Samplable`` using [inverse transform sampling].
///
/// Distributions that do not have a closed-form quantile can instead conform to ``Samplable`` directly with a custom sampling function.
/// For an example, ``ProbabilityDistribution`` conforms to ``Samplable`` using the Box–Muller transform.
///
/// [inverse transform sampling]:https://en.wikipedia.org/wiki/Inverse_transform_sampling
public protocol Samplable: ProbabilityDistribution {
    func sample() -> Value
}

extension Samplable {
    public func sample(count: Int) -> [Value] {
        (1...count).map { _ in sample() }
    }
}
