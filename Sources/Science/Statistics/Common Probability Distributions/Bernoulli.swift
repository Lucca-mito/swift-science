//
//  Bernoulli.swift
//  
//
//  Created by Lucca de Mello on 2023-04-15.
//

import RealModule

/// The probability distribution of a random variable that's either 0 or 1.
public struct BernoulliDistribution<Value, Statistic>
where
    Value: Comparable & Hashable & ExpressibleByIntegerLiteral,
    Statistic: Real & ExpressibleByFloatLiteral
{
    /// The probability of sampling 1 from the distribution.
    public let probabilityOfOne: Statistic
    
    /// The probability of sampling 0 from the distribution.
    public var probabilityOfZero: Statistic { 1 - probabilityOfOne }
    
    /// Creates a Bernoulli distribution with the given probability of sampling 1.
    public init(probabilityOfOne: Statistic) {
        self.probabilityOfOne = probabilityOfOne
    }
}

extension BernoulliDistribution {
    /// A probability distribution modeling a fair coin.
    public static var fair: BernoulliDistribution {
        BernoulliDistribution(probabilityOfOne: 0.5)
    }
}

extension BernoulliDistribution: ProbabilityDistribution {
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
    
    public var isSymmetric: Bool {
        [0, 0.5, 1].contains(probabilityOfOne)
    }
}

extension BernoulliDistribution: FiniteModal {
    public var modes: Set<Value> {
        switch probabilityOfOne {
        case 0 ..< 0.5:
            return [0]
        case 0.5:
            return [0, 1]
        default:
            return [1]
        }
    }
}

extension BernoulliDistribution: BoundedDistribution {
    public var min: Value { probabilityOfOne == 0 ? 1 : 0 }
    public var max: Value { probabilityOfOne == 0 ? 0 : 1 }
}

extension BernoulliDistribution: Moments {
    public var mean: Statistic { probabilityOfOne }
    
    public var variance: Statistic { probabilityOfOne * probabilityOfZero }
    
    public var skewness: Statistic {
        (probabilityOfZero - probabilityOfOne) / .sqrt(probabilityOfOne * probabilityOfZero)
    }

    public func momentGeneratingFunction(_ t: some BinaryInteger) -> Statistic {
        precondition(0 <= t)
        return probabilityOfZero + probabilityOfOne * .exp(Statistic(t))
    }
}

extension BernoulliDistribution: ClosedFormQuantile {
    public func quantile(_ quantileFraction: Statistic) -> Value {
        precondition(0 <= quantileFraction && quantileFraction <= 1)
        return quantileFraction > probabilityOfZero ? 1 : 0
    }
}

extension BernoulliDistribution: BoundedDiscreteDistribution {
    public static var domain: Set<Value> { [0, 1] }
    
    public var support: Set<Value> {
        switch probabilityOfOne {
        case 0: return [0]     // The value 1 can never be sampled, so the domain is [0].
        case 1: return [1]     // The value 1 is always sampled, so the domain is [1].
        default: return [0, 1] // Both 0 and 1 can be sampled.
        }
    }
}

extension BernoulliDistribution: Samplable
where
    Statistic: BinaryFloatingPoint,
    Statistic.RawSignificand: FixedWidthInteger
{
    /// Generates a random sample from the Bernoulli distribution.
    public func sample() -> Value {
        Statistic.random(in: 0..<1) < probabilityOfOne ? 1 : 0
    }
}
