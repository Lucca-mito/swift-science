//
//  ProbabilityDistribution.swift
//
//
//  Created by Lucca de Mello on 4/15/23.
//

public protocol ProbabilityDistribution {
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
}

// MARK: - Common statistics of probability distributions.
extension ProbabilityDistribution {
    var standardDeviation: RealType { .sqrt(variance) }
    
    // TODO: When moment-generating functions are added, add skewness and kurtosis.
}

// MARK: - Probabilities derived from CDF and PMF.
extension ProbabilityDistribution {
    public func probability(ofNot value: Value) -> RealType {
        1 - probability(ofExactly: value)
    }
    
    public func probability(ofLessThan value: Value) -> RealType {
        probability(ofAtMost: value) - probability(ofExactly: value)
    }
    
    public func probability(ofGreaterThan value: Value) -> RealType {
        1 - probability(ofAtMost: value)
    }
    
    public func probability(ofAtLeast value: Value) -> RealType {
        1 - probability(ofLessThan: value)
    }
    
    public func probability(ofIn range: Range<Value>) -> RealType {
        probability(ofLessThan: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
    
    public func probability(ofIn range: ClosedRange<Value>) -> RealType {
        probability(ofAtMost: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
    
    public func probability(ofIn collection: some Collection<Value>) -> RealType {
        collection.reduce(0) { total, value in total + probability(ofExactly: value) }
    }
    
    public func probability(ofWithin tolerance: Value, from center: Value) -> RealType {
        probability(ofIn: center - tolerance ... center + tolerance)
    }
}
