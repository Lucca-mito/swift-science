//
//  Bernoulli.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

public struct BernoulliDistribution<RealType: BinaryReal>: IntegerDistribution, ClosedFormQuantile {
    public let p: RealType
    
    public var mean: RealType { p }
    public var variance: RealType { p * (1 - p) }
    
    public var isSymmetric: Bool { [0, 0.5, 1].contains(p) }
    
    public init(p: RealType) {
        self.p = p
    }
    
    public func probability(ofExactly value: Value) -> RealType {
        switch value {
        case 0:
            return 1 - p
        case 1:
            return p
        default:
            return 0
        }
    }
    
    public func probability(ofAtMost value: Int) -> RealType {
        switch value {
        case _ where value < 0:
            return 0
        case 0:
            return 1 - p
        default:
            return 1
        }
    }
    
    public func quantile(_ quantileFraction: RealType) -> Int {
        precondition(0 <= quantileFraction && quantileFraction <= 1)
        return quantileFraction > 1 - p ? 1 : 0
    }
}

extension BernoulliDistribution {
    /// Models a fair coin.
    public static var fair: BernoulliDistribution {
        BernoulliDistribution(p: 1/2)
    }
}
