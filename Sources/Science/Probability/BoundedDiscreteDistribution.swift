//
//  BoundedDiscreteDistribution.swift
//
//
//  Created by Lucca de Mello on 4/23/23.
//

/// A discrete distribution that is bounded.
public protocol BoundedDiscreteDistribution:
    DiscreteDistribution, BoundedDistribution, Moments, ClosedFormQuantile {}
