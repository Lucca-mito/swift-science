//
//  NormalDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

import RealModule

/// A [normal distribution], also known as a Gaussian distribution.
///
/// [normal distribution]:https://en.wikipedia.org/wiki/Normal_distribution
public struct NormalDistribution<Statistic: Real> {
    public let mean: Statistic
    public let variance: Statistic
    
    public let isSymmetric = true
    
    public init(mean: Statistic, variance: Statistic) {
        self.mean = mean
        self.variance = variance
    }
    
    public init(mean: Statistic, standardDeviation: Statistic) {
        self.mean = mean
        self.variance = .pow(standardDeviation, 2)
    }
}

extension NormalDistribution {
    public static var standard: NormalDistribution {
        NormalDistribution(mean: 0, standardDeviation: 1)
    }
}

extension NormalDistribution: ContinuousDistribution {
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
}

extension NormalDistribution: MomentGeneratable {
    func momentGeneratingFunction(_ t: Int) -> Statistic {
        precondition(0 <= t)
        let t = Statistic(t)
        return .exp(mean * t) + variance * .pow(t, 2) / 2
    }
    
    var skewness: Statistic { 0 }
}

extension NormalDistribution: ClosedFormMedian {
    public var median: Statistic { mean }
}

extension NormalDistribution: Samplable where Statistic: BinaryFloatingPoint, Statistic.RawSignificand: FixedWidthInteger {
    public func sample() -> Value {
        // TODO: Implement the Box–Muller transform.
        fatalError("TODO")
    }
}
