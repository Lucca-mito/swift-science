//
//  BoundedDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

public protocol BoundedDistribution: ProbabilityDistribution {
    var min: Value { get }
    var max: Value { get }
}
