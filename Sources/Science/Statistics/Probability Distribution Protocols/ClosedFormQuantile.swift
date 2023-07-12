//
//  ClosedFormQuantile.swift
//  
//
//  Created by Lucca de Mello on 2023-04-16.
//

/// A probability distribution with a closed-form quantile function.
public protocol ClosedFormQuantile: ClosedFormMedian {
    /// The distribution's [quantile function].
    /// - Parameter quantileFraction: A probability.
    /// - Returns: The smallest ``ProbabilityDistribution/Value`` `x` such that
    /// `probability(ofAtMost: x) ≥ quantileFraction`.
    ///
    /// If the distribution's cumulative density function is strictly increasing, then `quantile(p)` is the unique
    /// ``ProbabilityDistribution/Value`` `x` such that `probability(ofAtMost: x) == quantileFraction`.
    ///
    /// > See: ``ProbabilityDistribution/probability(ofAtMost:)``
    ///
    /// [quantile function]: https://en.wikipedia.org/wiki/Quantile_function
    func quantile(_ quantileFraction: Statistic) -> Value
}

extension ClosedFormQuantile where Statistic: ExpressibleByFloatLiteral {
    public var median: Value { quantile(0.5) }
    
    /// A first percentile of the distribution.
    ///
    /// If there are multiple, the smallest is chosen.
    public var bottomOnePercent: Value { quantile(0.01) }
    
    /// A 99th percentile of the distribution.
    ///
    /// If there are multiple, the smallest is chosen.
    public var topOnePercent: Value { quantile(0.99) }
}

extension ClosedFormQuantile where Statistic: BinaryFloatingPoint, Statistic.RawSignificand: FixedWidthInteger {
    /// A default sampling function using inverse transform sampling.
    ///
    /// > Tip: This default implementation makes it easy for distributions conforming to ``ClosedFormQuantile`` to also conform to
    /// ``Samplable``. Distributions can choose to override this default implementation with a faster sampling function; for
    /// example, ``BernoulliDistribution`` does this.
    public func sample() -> Value {
        quantile(.random(in: 0...1))
    }
}
