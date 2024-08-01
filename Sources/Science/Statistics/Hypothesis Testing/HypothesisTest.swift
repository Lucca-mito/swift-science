//
//  HypothesisTest.swift
//  
//
//  Created by Lucca de Mello on 2023-08-01.
//

import RealModule

/// A tool to decide whether there is sufficient evidence to reject a statistical hypothesis.
///
/// ## Definitions
/// A *statistical hypothesis* is a constraint on a population parameter. For example, the parameter could be the population mean and
/// the constraint could be that it's less than 10.
///
/// The statistical hypothesis being tested is always the *null hypothesis*. Informally, it represents the "status quo" hypothesis: nothing
/// interesting is going on, the current theory is correct, there are no new effects, etc.
///
/// The null hypothesis is tested against an *alternative hypothesis*, which states that something interesting or unexpected is
/// happening: the old theory needs to be updated, new previously-unseen effects are present, etc.
///
/// ## Example
/// You can run a Wald test if the population parameter of interest to the hypothesis is the population mean (or any other parameter
/// satisfying certain constraints; see ``WaldTest``). To test whether the population mean equals 0:
/// ```swift
/// WaldTest(doesMeanEqual: 0).test(on: data)
/// ```
public protocol HypothesisTest {
    /// The type used for sample data. 
    ///
    /// If the hypothesis test concerns a single statistical population, `Sample` is usually `[Double]`.
    ///
    /// If the test concerns _two_ populations, e.g. when testing whether two populations have the same mean, `Sample` is usually
    /// `([Double], [Double])`. For an example of this, see ``WaldTest/sameMean``.
    associatedtype Sample
    
    /// A function of the dataset that characterizes a type of hypothesis test.
    ///
    /// You rarely need to use this function directly. Use ``test(on:atLevel:)`` or ``pValue(for:)`` instead.
    func testStatistic(_ sample: Sample) -> Double
    
    /// Calculates the critical value of the test.
    ///
    /// - Parameters:
    ///   - level: The desired ``ProbabilityOfTypeIError`` for the test.
    ///   - sample: The sample data to run the test on. In some tests, such as the ``WaldTest``, the `criticalValue`
    ///   depends only on the level and ignores this parameter.
    ///
    /// - Returns: The critical value of the test. If the ``testStatistic(_:)`` exceeds this value, the null hypothesis is
    /// rejected.
    ///
    /// You rarely need to use this function directly. Use ``test(on:atLevel:)`` or ``pValue(for:)`` instead.
    func criticalValue(at level: ProbabilityOfTypeIError, for sample: Sample) -> Double
    
    /// Runs the hypothesis test on the given `data` and reports the p-value
    ///
    /// - Parameter sample: The data to run the test on.
    ///
    /// - Returns: The smallest level at which the test rejects the null hypothesis.
    /// In other words, it's the smallest ``ProbabilityOfTypeIError`` for this test given the `data`.
    ///
    /// The closer the p-value is to 0, the more confident we can be that the data is incompatible with the null hypothesis.
    func pValue(for sample: Sample) -> ProbabilityOfTypeIError
}

extension HypothesisTest {
    /// Runs the hypothesis test on the given `data` and either *rejects* or *fails to reject* the null hypothesis.
    ///
    /// - Parameters:
    ///   - sample: The sample data to run the test on.
    ///   - level: If the null hypothesis is true, this is the probability that the test rejects it anyway. Denoted by 𝛼 in statistical
    ///   literature and more accurately known as the *test size*.
    ///
    /// - Returns: Whether the null hypothesis has been rejected.
    ///
    /// To get a p-value, use ``pValue(for:)`` instead.
    public func test(
        on sample: Sample,
        atLevel level: ProbabilityOfTypeIError = .lowProbability
    ) -> HypothesisTestOutcome {
        if testStatistic(sample) > criticalValue(at: level, for: sample) {
            return .reject
        } else {
            return .failToReject
        }
    }
}
