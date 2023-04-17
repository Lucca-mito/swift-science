//
//  NormalDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

import Numerics

public struct NormalDistribution<RealType: BinaryReal>: ContinuousDistribution {
    public let mean: RealType
    public let variance: RealType
    
    public let isSymmetric = true
    
    public init(mean: RealType, variance: RealType) {
        self.mean = mean
        self.variance = variance
    }
    
    public init(mean: RealType, standardDeviation: RealType) {
        self.mean = mean
        self.variance = .pow(standardDeviation, 2)
    }
    
    public func probabilityDensity(at value: RealType) -> RealType {
        let numerator: RealType = .exp(-.pow(value - mean, 2) / variance / 2)
        let denominator: RealType = .sqrt(2 * variance * .pi)
        return numerator / denominator
    }
    
    public func probability(ofAtMost value: RealType) -> RealType {
        .erfc(
            (mean - value) /
            (.sqrt(2) * standardDeviation)
        ) / 2
    }
    
    public func quantile(_ quantileFraction: RealType) -> RealType {
        fatalError("Not implemented.")
    }
}

extension NormalDistribution {
    public static var standard: NormalDistribution {
        NormalDistribution(mean: 0, standardDeviation: 1)
    }
}
