//
//  ProbabilityDistribution.swift
//
//
//  Created by Lucca de Mello on 4/15/23.
//

import RealModule

public protocol ProbabilityDistribution {
    associatedtype Value: Comparable
    
    /// The type used for probabilities and statistics of this distribution.
    ///
    /// For ``ContinuousDistribution``s, this type is the same as ``Value``.
    associatedtype Statistic: Real
    
    var isSymmetric: Bool { get }
    
    func probability(ofExactly value: Value) -> Statistic
    func probability(ofAtMost value: Value) -> Statistic
}

// MARK: - Probabilities derived from CDF and PMF.

extension ProbabilityDistribution {
    public func probability(ofNot value: Value) -> Statistic {
        1 - probability(ofExactly: value)
    }
    
    public func probability(ofLessThan value: Value) -> Statistic {
        probability(ofAtMost: value) - probability(ofExactly: value)
    }
    
    public func probability(ofGreaterThan value: Value) -> Statistic {
        1 - probability(ofAtMost: value)
    }
    
    public func probability(ofAtLeast value: Value) -> Statistic {
        1 - probability(ofLessThan: value)
    }
    
    public func probability(ofIn collection: some Collection<Value>) -> Statistic {
        collection.reduce(0) { total, value in total + probability(ofExactly: value) }
    }

    public func probability(ofIn range: Range<Value>) -> Statistic {
        probability(ofLessThan: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
    
    public func probability(ofIn range: ClosedRange<Value>) -> Statistic {
        probability(ofAtMost: range.upperBound) - probability(ofLessThan: range.lowerBound)
    }
}

extension ProbabilityDistribution where Value: AdditiveArithmetic {
    public func probability(ofWithin tolerance: Value, from center: Value) -> Statistic {
        probability(ofIn: center - tolerance ... center + tolerance)
    }
}
