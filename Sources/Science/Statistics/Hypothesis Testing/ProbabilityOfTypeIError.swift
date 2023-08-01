//
//  ProbabilityOfTypeIError.swift
//  
//
//  Created by Lucca de Mello on 2023-08-02.
//

/// A probability of rejecting a null hypothesis when it is true.
///
/// Used for the `level` parameter of ``HypothesisTest/test(on:atLevel:)``.
/// - A `ProbabilityOfTypeIError` of 0 corresponds to *never* rejecting the null hypothesis, so a test at this level is too strict.
/// - A `ProbabilityOfTypeIError` of 1 corresponds to *always* rejecting the null hypothesis, so a test at this level is not strict enough.
public typealias ProbabilityOfTypeIError = Double

extension ProbabilityOfTypeIError {
    /// A probability of Type I Error that is commonly accepted as being low.
    ///
    /// Corresponds to a probability of 𝛼 = 0.05. A hypothesis test at this level is conservative about rejecting the null hypothesis.
    /// So, if it *does* reject the null hypothesis anyway, there is strong evidence against the null hypothesis.
    public static let lowProbability: ProbabilityOfTypeIError = 0.05
    
    /// A probability of Type I Error that is commonly accepted as being very low.
    ///
    /// Corresponds to a probability of 𝛼 = 0.01. A hypothesis test at this level is very conservative about rejecting the null hypothesis.
    /// So, if it *does* reject the null hypothesis anyway, there is very strong evidence against the null hypothesis.
    public static let veryLowProbability: ProbabilityOfTypeIError = 0.01
}
