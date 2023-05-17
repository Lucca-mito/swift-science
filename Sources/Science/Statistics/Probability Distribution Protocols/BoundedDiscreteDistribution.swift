//
//  BoundedDiscreteDistribution.swift
//
//
//  Created by Lucca de Mello on 4/23/23.
//

/// A distribution over a finite set of values.
///
/// Such a distribution always has a ``DistributionWithMean/mean``, a ``DistributionWithVariance/variance``,
/// and all other ``Moments``. Additionally, a `BoundedDiscreteDistribution` always has a ``ClosedFormQuantile``.
public protocol BoundedDiscreteDistribution:
    DiscreteDistribution, BoundedDistribution, Moments, ClosedFormQuantile {}
