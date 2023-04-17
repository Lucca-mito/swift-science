//
//  NormalDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

import Numerics

struct NormalDistribution<RealType: BinaryReal>: ContinuousDistribution {
    let mean: RealType
    let variance: RealType
    
    let isSymmetric = true
    
    init(mean: RealType, variance: RealType) {
        self.mean = mean
        self.variance = variance
    }
    
    init(mean: RealType, standardDeviation: RealType) {
        self.mean = mean
        self.variance = .pow(standardDeviation, 2)
    }
    
    func probabilityDensity(at value: RealType) -> RealType {
        let numerator: RealType = .exp(-.pow(value - mean, 2) / variance / 2)
        let denominator: RealType = .sqrt(2 * variance * .pi)
        return numerator / denominator
    }
    
    func probability(ofAtMost value: RealType) -> RealType {
        .erfc(
            (mean - value) /
            (.sqrt(2) * standardDeviation)
        ) / 2
    }
    
    func quantile(_ quantileFraction: RealType) -> RealType {
        fatalError("Not implemented.")
    }
}

extension NormalDistribution {
    static var standard: NormalDistribution {
        NormalDistribution(mean: 0, standardDeviation: 1)
    }
}
