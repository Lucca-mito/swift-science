//
//  WaldTest.swift
//  
//
//  Created by Lucca de Mello on 2023-08-01.
//

import RealModule

/// A two-sided hypothesis test using a normally-distributed parameter estimator.
///
/// Use the Wald test only if the estimator of the parameter of interest is approximately normally-distributed.
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
/// If the Wald test is appropriate, you can use ``doesMeanEqual(_:)`` to create a Wald test of the population mean.
///
/// ## Examples
/// Computing the p-value for whether a population mean equals 𝜋:
/// ```swift
/// WaldTest.doesMeanEqual(.pi).test(on: sample)
/// ```
///
/// Testing whether two populations have the same mean:
/// ```swift
/// WaldTest.doMeansDiffer().test(on: samples)
/// ```
public enum WaldTest {}

extension WaldTest {
    /// Creates any Wald test. There are convenience wrappers around this function for specific types of Wald test, such as ``doesMeanEqual(_:)``.
    ///
    /// - Parameters:
    ///   - parameterEstimator: A function that estimates the parameter of interest from a data sample.
    ///   For example: if the parameter of interest is the population mean, the `parameterEstimator` is the sample-mean function.
    ///
    ///   - parameterValueUnderNullHypothesis: The value of the parameter of interest under the null hypothesis. Usually 0.
    ///
    ///   - standardErrorEstimator: A function that estimates the standard error of `parameterEstimator` from a data sample.
    ///
    /// - Returns: A Wald test for the null hypothesis 𝜃 = `parameterValueUnderNullHypothesis` where 𝜃 is the parameter of interest.
    ///
    public static func general<DataType>(
        parameterEstimator: @escaping ([DataType]) -> Double,
        parameterValueUnderNullHypothesis: Double,
        standardErrorEstimator:  @escaping ([DataType]) -> Double
    ) -> HypothesisTest<DataType>
    {
        // A helper function used to initialize the Wald test. Namely, it's passed as the
        // testStatistic parameter (and used by the pValue parameter) of HypothesisTest.init.
        func waldTestStatistic(_ data: [DataType]) -> Double {
            let thetaHat = parameterEstimator(data)
            let thetaNaught = parameterValueUnderNullHypothesis
            let seHat = standardErrorEstimator(data)
            
            return abs((thetaHat - thetaNaught) / seHat)
        }
        
        return HypothesisTest(
            testStatistic: waldTestStatistic,
            
            // The critical value of a Wald test depends only on the level, and not on the sample size.
            // criticalValue = Φ⁻¹(α/2) where Φ is the standard normal CDF.
            criticalValue: { level, _ in
                -NormalDistribution<Double>.standard.quantile(level / 2)
            },
            
            // pValue = 2Φ(W(X)) where Φ is the standard normal CDF and W(X) is the Wald statistic of dataset X.
            pValue: { data in
                let normalCDF = NormalDistribution<Double>.standard.probability(ofAtMost:)
                return 2 * normalCDF(waldTestStatistic(data))
            }
        )
    }
    
    /// Creates a Wald test for whether a population mean equals the specified value.
    /// - Parameter meanUnderNullHypothesis: The population mean if the null hypothesis is true.
    /// - Returns: A Wald test for the null hypothesis µ = `meanUnderNullHypothesis` where µ is the population mean.
    public static func doesMeanEqual(_ meanUnderNullHypothesis: Double) -> HypothesisTest<Double> {
        general(
            parameterEstimator: { $0.mean() },
            parameterValueUnderNullHypothesis: meanUnderNullHypothesis,
            standardErrorEstimator: { data in
                .sqrt(data.sampleVariance() / Double(data.count))
            }
        )
    }
    
    /// Creates a Wald test for whether the difference between two population means equals the specified value.
    /// - Parameter differenceUnderNullHypothesis: The difference between the two population means if the null hypothesis is true.
    /// - Returns: A Wald test for the null hypothesis 𝑋̅ - 𝑌̅ = `differenceUnderNullHypothesis`  where 𝑋̅ and 𝑌̅ are the population means.
    public static func doMeansDiffer(
        by differenceUnderNullHypothesis: Double = 0
    ) -> HypothesisTest<(Double, Double)> {
        general(
            parameterEstimator: { $0.differenceOfMeans() },
            parameterValueUnderNullHypothesis: differenceUnderNullHypothesis,
            standardErrorEstimator: { data in
                let first = data.map(\.0).sampleVariance() / Double(data.count)
                let second = data.map(\.1).sampleVariance() / Double(data.count)
                return .sqrt(first + second)
            }
        )
    }
}
