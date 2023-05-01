//
//  Bernoulli.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

import RealModule

public struct BernoulliDistribution<Value, Statistic>
where
    Value: Comparable & ExpressibleByIntegerLiteral,
    Statistic: Real & ExpressibleByFloatLiteral
{
    public let p: Statistic
    public var q: Statistic { 1 - p }
    
    public var isSymmetric: Bool { [0, 0.5, 1].contains(p) }
    
    public init(p: Statistic) {
        self.p = p
    }
}

extension BernoulliDistribution {
    /// Models a fair coin.
    public static var fair: BernoulliDistribution {
        BernoulliDistribution(p: 0.5)
    }
}

extension BernoulliDistribution: BoundedDiscreteDistribution {
    // MARK: - DiscreteDistribution conformance
    
    public func probability(ofExactly value: Value) -> Statistic {
        switch value {
        case 0:
            return q
        case 1:
            return p
        default:
            return 0
        }
    }
    
    public func probability(ofAtMost value: Value) -> Statistic {
        switch value {
        case _ where value < 0:
            return 0
        case 0:
            return q
        default:
            return 1
        }
    }
    
    // MARK: - BoundedDistribution conformance
    
    public var min: Value { p == 0 ? 1 : 0 }
    public var max: Value { p == 0 ? 0 : 1 }
    
    // MARK: - Moments conformance
    
    public var mean: Statistic { p }
    
    public var variance: Statistic { p * q }

    public func momentGeneratingFunction(_ t: Int) -> Statistic {
        precondition(0 <= t)
        return q + p * .exp(Statistic(t))
    }

    public var skewness: Statistic {
        (q - p) / .sqrt(p * q)
    }
    
    // MARK: - ClosedFormQuantile conformance
    
    public func quantile(_ quantileFraction: Statistic) -> Value {
        precondition(0 <= quantileFraction && quantileFraction <= 1)
        return quantileFraction > q ? 1 : 0
    }
}

extension BernoulliDistribution: Samplable
where
    Statistic: BinaryFloatingPoint,
    Statistic.RawSignificand: FixedWidthInteger {}
