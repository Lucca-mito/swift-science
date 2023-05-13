//
//  DiscreteDistribution.swift
//
//
//  Created by Lucca de Mello on 4/15/23.
//

import RealModule

/// A [discrete probability distribution].
///
/// [discrete probability distribution]:https://en.wikipedia.org/wiki/Probability_distribution#Discrete_probability_distribution
public protocol DiscreteDistribution: ProbabilityDistribution {}

// Note that DiscreteDistribution does not inherit from DistributionWithMean. Not every discrete
// distribution has a mean! For example,
// - The distribution with CDF `F(n) = 1 - 1/n` over the integers `n = 1, 2, ...` never has a mean.
// - The Zeta distribution may or may not have a mean.
// See also the St. Petersburg paradox.
