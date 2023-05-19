//
//  ClosedFormMedian.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

/// A probability distribution with a closed-form median.
public protocol ClosedFormMedian: ProbabilityDistribution {
    /// A median of the distribution.
    ///
    /// If there are multiple medians, the smallest is chosen.
    var median: Value { get }
}
