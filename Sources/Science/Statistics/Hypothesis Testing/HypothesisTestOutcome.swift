//
//  HypothesisTestOutcome.swift
//  
//
//  Created by Lucca de Mello on 2023-08-08.
//

/// Either `reject` or `failToReject` the null hypothesis.
public enum HypothesisTestOutcome {
    /// Indicates sufficient evidence to reject the null hypothesis.
    ///
    /// This does not necessarily mean that we should *accept* the alternative hypothesis. For example, it could be that an
    /// improbable event has occurred during data sampling (meaning that the sampled data is an outlier, not the norm).
    case reject
    
    /// Indicates insufficient evidence to reject the null hypothesis.
    ///
    /// This does not necessarily mean that the null hypothesis is true. For example, it could be that the sample size is simply not
    /// large enough to conclusively reject the null hypothesis.
    case failToReject
}
