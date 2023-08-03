//
//  HypothesisTest.swift
//  
//
//  Created by Lucca de Mello on 2023-08-01.
//

import RealModule

/// A statistical tool to decide whether a dataset rejects a hypothesis about a population parameter.
///
/// ## Example
/// If the parameter of interest is the mean (or is any other parameter with a normally-distributed estimator), a Wald test is appropriate:
/// ```swift
/// WaldTest.doesMeanEqual(0).test(on: data)
/// ```
public struct HypothesisTest<DataType> {
    /// A function of the dataset that characterizes a type of hypothesis test.
    private let testStatistic: ([DataType]) -> Double
    
    /// A function mapping the level and the sample size to the test's critical value.
    private let criticalValue: (Double, Int) -> Double
    
    /// ``pValue(for:)`` wraps this closure, adding an external label to the data parameter in the public interface.
    private let pValue: ([DataType]) -> Double
    
    /// Initializes the hypothesis test so it can be run on a data sample.
    ///
    /// - Parameters:
    ///   - testStatistic: A function of the dataset that characterizes a type of hypothesis test.
    ///   The test rejects the null hypothesis if `testStatistic(data)` exceeds the test's critical value.
    ///
    ///   - criticalValue: A function mapping the level (see ``test(on:atLevel:)``) and the sample size to the test's
    ///   critical value. If the test statistic exceeds this value, the null hypothesis is rejected. In some tests, such as the ``WaldTest``,
    ///   the `criticalValue` depends only on the level and ignores the sample size.
    ///
    ///   - pValue: A function mapping the dataset to the reported p-value. ``pValue(for:)`` wraps this closure.
    public init(
        testStatistic: @escaping ([DataType]) -> Double,
        criticalValue: @escaping (ProbabilityOfTypeIError, Int) -> Double,
        pValue:        @escaping ([DataType]) -> ProbabilityOfTypeIError
    ) {
        self.testStatistic = testStatistic
        self.criticalValue = criticalValue
        self.pValue = pValue
    }
}

extension HypothesisTest {
    /// Either `reject` or `failToReject` the null hypothesis.
    public enum Outcome {
        /// The test has rejected the null hypothesis.
        ///
        /// This does not necessarily mean that we should *accept* the alternative hypothesis. For example, it could be that an
        /// improbable event has occurred during data sampling (meaning that the sampled data is an outlier, not the norm).
        case reject
        
        /// The test has failed to reject the null hypothesis.
        ///
        /// This does not necessarily mean that the null hypothesis is true. For example, it could be that the sample size is simply not
        /// large enough to conclusively reject the null hypothesis.
        case failToReject
    }
    
    /// Runs the hypothesis test on the given `data` and either *rejects* or *fails to reject* the null hypothesis.
    ///
    /// - Parameters:
    ///   - data: The data to run the test on.
    ///   - level: If the null hypothesis is true, this is the probability that the test rejects it anyway. Denoted by 𝛼 in statistical
    ///   literature and more accurately known as the *test size*.
    ///
    /// - Returns: Whether the null hypothesis has been rejected.
    ///
    /// To get a p-value, use ``pValue(for:)`` instead.
    public func test(
        on data: [DataType],
        atLevel level: ProbabilityOfTypeIError = .lowProbability
    ) -> Outcome {
        if testStatistic(data) > criticalValue(level, data.count) {
            return .reject
        } else {
            return .failToReject
        }
    }
    
    /// Runs the hypothesis test on the given `data` and reports the p-value
    ///
    /// - Parameter data: The data to run the test on.
    ///
    /// - Returns: The smallest level at which the test rejects the null hypothesis.
    /// In other words, it's the smallest ``ProbabilityOfTypeIError`` for this test given the `data`.
    ///
    /// The closer the p-value is to 0, the more confident we can be that the data is incompatible with the null hypothesis.
    public func pValue(for data: [DataType]) -> Double {
        pValue(data)
    }
}
