//
//  ContinuousDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/15/23.
//

public protocol ContinuousDistribution: ProbabilityDistribution where Value == RealType {
    func probabilityDensity(at value: Value) -> RealType
}

extension ContinuousDistribution {
    public func probability(ofExactly value: Value) -> RealType { 0 }
}
