//
//  Samplable.swift
//  
//
//  Created by Lucca de Mello on 2023-04-16.
//

/// A probability distribution that can be randomly sampled.
///
/// Sample one random ``ProbabilityDistribution/Value`` from the distribution with the ``sample()`` method, or sample
/// `count` random values with ``sample(count:)``.
///
/// ## Conforming to the Samplable protocol
/// Creating a custom probability distribution conforming to `Samplable` only requires implementing the ``sample()`` function.
///
/// > Tip: All probability distributions conforming to ``ClosedFormQuantile`` automatically get a ``sample()`` implementation
/// that uses [inverse transform sampling]. Distributions that don't have a closed-form quantile can instead conform to
/// `Samplable` with a custom sampling function. For example, ``NormalDistribution`` conforms to `Samplable` using
/// the Box–Muller transform.
///
/// > See: The default ``ClosedFormQuantile/sample()`` function in ``ClosedFormQuantile``.
///
/// [inverse transform sampling]:https://en.wikipedia.org/wiki/Inverse_transform_sampling
public protocol Samplable: ProbabilityDistribution {
    /// Generates one random ``ProbabilityDistribution/Value`` sampled from the probability distribution.
    /// - Returns: A single random value from the distribution.
    func sample() -> Value
}

extension Samplable {
    /// Generates indepenent random ``ProbabilityDistribution/Value``s from the probability distribution.
    /// - Parameter count: How many values to generate.
    /// - Returns: An array of `count` independent random values from the probability distribution.
    public func sample(count: Int) -> [Value] {
        (1...count).map { _ in sample() }
    }
}
