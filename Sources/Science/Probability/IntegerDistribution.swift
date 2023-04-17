//
//  IntegerDistribution.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

/// A probability distribution over the integers.
///
/// ``IntegerDistribution``s have a ``ProbabilityDistribution/Value`` of `Int`.
/// To use other integer types, such as arbitrary-precision integers, create a distribution conforming to ``DiscreteDistribution`` directly instead.
public protocol IntegerDistribution: DiscreteDistribution where Value == Int {}
