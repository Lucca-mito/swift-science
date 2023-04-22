//
//  BoundedIntegerDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

/// A probability distribution over a finite set of integers.
///
/// Since ``BoundedIntegerDistribution``s don't need to support arbitrary-precision integers, they have a concrete ``ProbabilityDistribution/Value`` type of `Int` instead of a generic ``ProbabilityDistribution/Value`` type. This reduces boilerplate when conforming to this protocol.
///
/// Integer distributions that are *not* bounded should support arbitrary-precision integer ``ProbabilityDistribution/Value``s, so they should conform to ``DiscreteDistribution`` directly instead of conforming to this protocol.
public protocol BoundedIntegerDistribution: DiscreteDistribution, BoundedDistribution where Value == Int {}
