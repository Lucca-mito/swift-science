//
//  Bernoulli.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

import Numerics

struct BernoulliDistribution<RealType: BinaryReal>: IntegerDistribution {
    let p: RealType
    
    var mean: RealType { p }
    var variance: RealType { p * (1 - p) }
    
    var isSymmetric: Bool { p == 0 }
    
    func probability(ofExactly value: Value) -> RealType {
        switch value {
        case 0:
            return 1 - p
        case 1:
            return p
        default:
            return 0
        }
    }
    
    func probability(ofAtMost value: Int) -> RealType {
        switch value {
        case _ where value < 0:
            return 0
        case 0:
            return 1 - p
        default:
            return 1
        }
    }
    
    func quantile(_ quantileFraction: RealType) -> Int {
        precondition(0 <= quantileFraction && quantileFraction <= 1)
        return quantileFraction > 1 - p ? 1 : 0
    }
}

extension BernoulliDistribution {
    /// Models a fair coin.
    static var fair: BernoulliDistribution {
        BernoulliDistribution(p: 1/2)
    }
}
