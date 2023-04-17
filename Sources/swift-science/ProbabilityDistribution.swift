//
//  ProbabilityDistribution.swift
//
//
//  Created by Lucca de Mello on 4/15/23.
//

import Numerics

protocol ProbabilityDistribution {
    associatedtype Value: Comparable, AdditiveArithmetic
    
    /// The type used for probabilities and statistics of this distribution.
    ///
    /// For ``ContinuousDistribution``s, this type is the same as ``Value``.
    associatedtype RealType: BinaryReal
    
    var mean: RealType { get }
    var variance: RealType { get }
    
    var isSymmetric: Bool { get }
    
    func probability(ofExactly value: Value) -> RealType
    func probability(ofAtMost value: Value) -> RealType
    
    func quantile(_ quantileFraction: RealType) -> Value
}

// MARK: - Common statistics of probability distributions.
extension ProbabilityDistribution {
    var standardDeviation: RealType { .sqrt(variance) }
    
    // TODO: When moment-generating functions are added, add skewness and kurtosis.
    
    // MARK: Quantile-derived statistics.
    
    /// A median of the distribution.
    ///
    /// If there are multiple medians, the smallest is chosen.
    ///
    /// If the distribution is symmetric and the ``mean`` can be converted to ``Value``, the median is calculated by returning the mean. Otherwise, the mean is calculated using ``quantile``.
    var median: Value {
        if isSymmetric, let mean = mean as? Value {
            return mean
        } else {
            return quantile(1/2)
        }
    }
    
    /// A first percentile of the distribution.
    ///
    /// If there are multiple, the smallest is chosen.
    var bottomOnePercent: Value { quantile(0.01) }
    
    /// A 99th percentile of the distribution.
    ///
    /// If there are multiple, the smallest is chosen.
    var topOnePercent: Value { quantile(0.99) }
}

// MARK: - Probabilities derived from CDF and PMF.
extension ProbabilityDistribution {
    func probability(ofNot value: Value) -> RealType {
        1 - probability(ofExactly: value)
    }
    
    func probability(ofLessThan value: Value) -> RealType {
        probability(ofAtMost: value) - probability(ofExactly: value)
    }
    
    func probability(ofGreaterThan value: Value) -> RealType {
        1 - probability(ofAtMost: value)
    }
    
    func probability(ofAtLeast value: Value) -> RealType {
        1 - probability(ofLessThan: value)
    }
    
    func probability(ofIn range: Range<Value>) -> RealType {
        probability(ofLessThan: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
    
    func probability(ofIn range: ClosedRange<Value>) -> RealType {
        probability(ofAtMost: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
    
    func probability(ofIn collection: some Collection<Value>) -> RealType {
        collection.reduce(0) { total, value in total + probability(ofExactly: value) }
    }
    
    func probability(ofWithin tolerance: Value, from center: Value) -> RealType {
        probability(ofIn: center - tolerance ... center + tolerance)
    }
}
