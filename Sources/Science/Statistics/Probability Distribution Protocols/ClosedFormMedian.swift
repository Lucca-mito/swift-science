//
//  ClosedFormMedian.swift
//  
//
//  Created by Lucca de Mello on 2023-04-16.
//

/// A probability distribution with a closed-form median.
public protocol ClosedFormMedian: ProbabilityDistribution {
    /// A median of the distribution.
    ///
    /// If there are multiple medians, the smallest is chosen.
    var median: Value { get }
}
