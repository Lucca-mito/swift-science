//
//  Bernoulli.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

import RealModule

/// The probability distribution of a random variable that's either 0 or 1.
public struct BernoulliDistribution<Value, Statistic>
where
    Value: Comparable & ExpressibleByIntegerLiteral,
    Statistic: Real & ExpressibleByFloatLiteral
{
    /// The probability of sampling 1 from this distribution.
    public let probabilityOfOne: Statistic
    
    /// The probability of sampling 0 from this distribution.
    public var probabilityOfZero: Statistic { 1 - probabilityOfOne }
    
    public init(probabilityOfOne: Statistic) {
        self.probabilityOfOne = probabilityOfOne
    }
}

extension BernoulliDistribution {
    /// Models a fair coin.
    public static var fair: BernoulliDistribution {
        BernoulliDistribution(probabilityOfOne: 0.5)
    }
}

extension BernoulliDistribution: BoundedDiscreteDistribution {
    // MARK: - DiscreteDistribution conformance
    
    public func probability(ofExactly value: Value) -> Statistic {
        switch value {
        case 0:
            return probabilityOfZero
        case 1:
            return probabilityOfOne
        default:
            return 0
        }
    }
    
    public func probability(ofAtMost value: Value) -> Statistic {
        switch value {
        case _ where value < 0:
            return 0
        case 0:
            return probabilityOfZero
        default:
            return 1
        }
    }
    
    public var isSymmetric: Bool { [0, 0.5, 1].contains(probabilityOfOne) }
    
    // MARK: - BoundedDistribution conformance
    
    public var min: Value { probabilityOfOne == 0 ? 1 : 0 }
    public var max: Value { probabilityOfOne == 0 ? 0 : 1 }
    
    // MARK: - Moments conformance
    
    public var mean: Statistic { probabilityOfOne }
    
    public var variance: Statistic { probabilityOfOne * probabilityOfZero }
    
    public var skewness: Statistic {
        (probabilityOfZero - probabilityOfOne) / .sqrt(probabilityOfOne * probabilityOfZero)
    }

    public func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic {
        precondition(0 <= t)
        return probabilityOfZero + probabilityOfOne * .exp(Statistic(t))
    }
    
    // MARK: - ClosedFormQuantile conformance
    
    public func quantile(_ quantileFraction: Statistic) -> Value {
        precondition(0 <= quantileFraction && quantileFraction <= 1)
        return quantileFraction > probabilityOfZero ? 1 : 0
    }
}

extension BernoulliDistribution: Samplable
where
    Statistic: BinaryFloatingPoint,
    Statistic.RawSignificand: FixedWidthInteger
{
    public func sample() -> Value {
        Statistic.random(in: 0..<1) < probabilityOfOne ? 1 : 0
    }
}
