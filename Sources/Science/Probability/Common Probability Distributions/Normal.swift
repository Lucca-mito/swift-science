//
//  NormalDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

public struct NormalDistribution<Statistic: Statistical>: ContinuousDistribution, ClosedFormMedian, Samplable {
    public let mean: Statistic
    public let variance: Statistic
    
    public let isSymmetric = true
    public var median: Statistic { mean }
    
    public init(mean: Statistic, variance: Statistic) {
        self.mean = mean
        self.variance = variance
    }
    
    public init(mean: Statistic, standardDeviation: Statistic) {
        self.mean = mean
        self.variance = .pow(standardDeviation, 2)
    }
    
    public func probabilityDensity(at value: Statistic) -> Statistic {
        let numerator: Statistic = .exp(-.pow(value - mean, 2) / variance / 2)
        let denominator: Statistic = .sqrt(2 * variance * .pi)
        return numerator / denominator
    }
    
    public func probability(ofAtMost value: Statistic) -> Statistic {
        .erfc(
            (mean - value) /
            (.sqrt(2) * standardDeviation)
        ) / 2
    }
    
    public func sample() -> Value {
        // TODO: Implement the Box–Muller transform.
        fatalError("TODO")
    }
}

extension NormalDistribution {
    public static var standard: NormalDistribution {
        NormalDistribution(mean: 0, standardDeviation: 1)
    }
}
