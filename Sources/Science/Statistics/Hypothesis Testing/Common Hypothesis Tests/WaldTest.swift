//
//  WaldTest.swift
//  
//
//  Created by Lucca de Mello on 2023-08-01.
//

import RealModule

/// A two-sided hypothesis test using a normally-distributed parameter estimator.
///
/// Use the Wald test only if the estimator `parameterEstimator` of the parameter of interest 𝜃 is approximately normally-distributed.
///
/// The Wald test rejects the null hypothesis 𝜃 = 𝜃₀ (for some real number 𝜃₀) on dataset 𝑋 at level 𝛼 if:
///
/// ![Numerator: parameter estimator minus theta_zero. Denominator: standard error estimator. Take the absolute value of that fraction. Greater than negative capital phi, to the power of negative 1, of alpha over 2.](wald-test-rejection-condition.svg)
///
/// where 𝚽⁻¹ is the standard normal ``NormalDistribution/quantile(_:)`` function. See
/// ``init(parameterEstimator:parameterValueUnderNullHypothesis:standardErrorEstimator:)``
/// for more information.
///
/// ## Wald test of the sample mean
/// For large sample sizes, the population mean is a parameter for which the Wald test is appropriate. Its estimator, the sample mean,
/// is approximately normally-distributed (for large sample sizes) by the [central limit theorem].
///
/// [central limit theorem]: https://en.wikipedia.org/wiki/Central_limit_theorem
///
/// For small sample sizes, the effects of the central limit theorem are not significant — that is, the
/// sample mean does not necessarily follow an approximate normal distribution — so the Wald test is not appropriate.
///
/// If the Wald test is appropriate, you can use ``init(doesMeanEqual:)`` to create a Wald test of the population mean.
///
/// ## Examples
/// Computing the p-value for whether a population mean equals 𝜋:
/// ```swift
/// WaldTest(doesMeanEqual: .pi).pValue(for: sample)
/// ```
///
/// Testing whether two populations have the same mean:
/// ```swift
/// WaldTest.sameMean.test(on: [xSample, ySample])
/// ```
public struct WaldTest<DataType>: HypothesisTest {
    /// A function that estimates the parameter of interest from a data sample.
    private let parameterEstimator: ([DataType]) -> Double
    
    /// The value of the parameter of interest under the null hypothesis.
    private let parameterValueUnderNullHypothesis: Double
    
    /// A function that estimates the standard error of `parameterEstimator`  from a data sample.
    private let standardErrorEstimator: ([DataType]) -> Double
    
    /// The Wald test statistic.
    public func testStatistic(_ data: [DataType]) -> Double {
        let thetaHat = parameterEstimator(data)
        let theta0 = parameterValueUnderNullHypothesis
        let seHat = standardErrorEstimator(data)
        
        return abs((thetaHat - theta0) / seHat)
    }
    
    /// Critical value of the Wald test. Depends only on the level, and not on the sample size.
    ///
    /// - Parameters:
    ///   - level: The desired probability of rejecting the null hypothesis if it's true.
    ///
    /// - Returns: The critical value:
    /// ![Capital phi to the power of negative 1, of level over 2.](wald-test-critical-value)
    /// where 𝚽⁻¹ is the standard normal ``NormalDistribution/quantile(_:)`` function.
    ///
    /// The second parameter is ignored, and is present solely because ``HypothesisTest`` requires it. Regardless, you rarely
    /// need to use this function directly; use ``test(on:atLevel:)`` or ``pValue(for:)`` instead.
    public func criticalValue(at level: ProbabilityOfTypeIError, for _: [DataType]) -> Double {
        -NormalDistribution.standard.quantile(level / 2)
    }
    
    /// Runs the Wald test on the given `data` and reports the p-value.
    /// - Parameter data: The data to compute the p-value for.
    /// - Returns: The p-value:
    /// ![2 phi of W of data](wald-test-p-value)
    /// where 𝚽 is the ``NormalDistribution/standard`` normal CDF (see
    /// ``NormalDistribution/probability(ofAtMost:)``) and 𝑊 is the Wald ``testStatistic(_:)``.
    public func pValue(for data: [DataType]) -> ProbabilityOfTypeIError {
        let normalCDF = NormalDistribution.standard.probability(ofAtMost:)
        return 2 * normalCDF(testStatistic(data))
    }
    
    /// Creates any Wald test. There are convenience wrappers around this initializer for specific types of Wald test, such as ``init(doesMeanEqual:)``.
    ///
    /// - Parameters:
    ///   - parameterEstimator: A function that estimates the parameter of interest from a data sample.
    ///   For example: if the parameter of interest is the population mean, the `parameterEstimator` is the sample-mean function.
    ///
    ///   - parameterValueUnderNullHypothesis: The value of the parameter of interest under the null hypothesis. Usually 0.
    ///
    ///   - standardErrorEstimator: A function that estimates the standard error of `parameterEstimator` from a data sample.
    ///
    /// This creates a Wald test for the null hypothesis 𝜃 = `parameterValueUnderNullHypothesis` where 𝜃 is the parameter of interest.
    public init(
        parameterEstimator: @escaping ([DataType]) -> Double,
        parameterValueUnderNullHypothesis: Double,
        standardErrorEstimator: @escaping ([DataType]) -> Double
    ) {
        self.parameterEstimator = parameterEstimator
        self.parameterValueUnderNullHypothesis = parameterValueUnderNullHypothesis
        self.standardErrorEstimator = standardErrorEstimator
    }
}

extension WaldTest where DataType == Double {
    /// Creates a Wald test for whether a population mean equals the specified value.
    ///
    /// - Parameter meanUnderNullHypothesis: The population mean if the null hypothesis is true.
    ///
    /// This creates a Wald test for the null hypothesis 𝜃 = `meanUnderNullHypothesis` where 𝜃 is the population mean.
    public init(doesMeanEqual meanUnderNullHypothesis: Double) {
        self.parameterEstimator = { $0.mean() }
        self.parameterValueUnderNullHypothesis = meanUnderNullHypothesis
        self.standardErrorEstimator = { data in
            .sqrt(data.sampleVariance() / Double(data.count))
        }
    }
}

extension WaldTest where DataType == [Double] {
    /// A Wald test for whether the two populations have the same mean.
    ///
    /// ## Usage
    /// ```swift
    /// let x: [Double]
    /// let y: [Double]
    ///
    /// if WaldTest.sameMean.test(on: [x, y]) == .reject {
    ///     print("The means (probably) differ!")
    /// }
    /// ```
    ///
    /// ## Discussion
    /// This Wald test has the null hypothesis 𝑋̅ - 𝑌̅ = 0  where 𝑋̅ and 𝑌̅ are the population means.
    ///
    /// When calling ``HypothesisTest/test(on:atLevel:)`` or ``WaldTest/pValue(for:)``, make sure the `data`
    /// consists of exactly 2 non-empty arrays.
    public static let sameMean = WaldTest(
        parameterEstimator: { samples in
            precondition(samples.count == 2)
            
            let firstSample = samples[0]
            let secondSample = samples[1]
            
            precondition(!firstSample.isEmpty && !secondSample.isEmpty)
            
            return firstSample.mean() - secondSample.mean()
        },
        
        parameterValueUnderNullHypothesis: 0,
        
        standardErrorEstimator: { samples in
            // The necessary preconditions are already handled by the parameterEstimator above.
            
            let firstSample = samples[0]
            let secondSample = samples[1]
            
            let firstStatistic = firstSample.sampleVariance() / Double(firstSample.count)
            let secondStatistic = secondSample.sampleVariance() / Double(secondSample.count)
            
            return .sqrt(firstStatistic + secondStatistic)
        }
    )
}
