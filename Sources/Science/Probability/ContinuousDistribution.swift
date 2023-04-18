//
//  ContinuousDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

public protocol ContinuousDistribution: ProbabilityDistribution where Value == Statistic {
    func probabilityDensity(at value: Value) -> Statistic
}

extension ContinuousDistribution {
    public func probability(ofExactly value: Value) -> Statistic { 0 }
}
