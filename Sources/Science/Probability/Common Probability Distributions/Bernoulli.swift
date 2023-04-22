//
//  Bernoulli.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

public struct BernoulliDistribution<Statistic: Statistical> {
    public let p: Statistic
    
    public var mean: Statistic { p }
    public var variance: Statistic { p * (1 - p) }
    
    public var isSymmetric: Bool { [0, 0.5, 1].contains(p) }
    
    public init(p: Statistic) {
        self.p = p
    }
    
    public func probability(ofExactly value: Value) -> Statistic {
        switch value {
        case 0:
            return 1 - p
        case 1:
            return p
        default:
            return 0
        }
    }
    
    public func probability(ofAtMost value: Int) -> Statistic {
        switch value {
        case _ where value < 0:
            return 0
        case 0:
            return 1 - p
        default:
            return 1
        }
    }
}

extension BernoulliDistribution {
    /// Models a fair coin.
    public static var fair: BernoulliDistribution {
        BernoulliDistribution(p: 1/2)
    }
}

extension BernoulliDistribution: BoundedIntegerDistribution {
    public var min: Value { 0 }
    public var max: Value { 1 }
}

extension BernoulliDistribution: ClosedFormQuantile {
    public func quantile(_ quantileFraction: Statistic) -> Int {
        precondition(0 <= quantileFraction && quantileFraction <= 1)
        return quantileFraction > 1 - p ? 1 : 0
    }
}
