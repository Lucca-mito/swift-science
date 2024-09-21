//
//  createHypothesisTest.swift
//  
//
//  Created by Lucca de Mello on 2023-08-08.
//

/// Creates a single custom ``HypothesisTest`` without having to declare a new type.
///
/// - Parameters:
///   - testStatistic: A function of the dataset that characterizes a type of hypothesis test.
///   The test rejects the null hypothesis if `testStatistic(data)` exceeds the test's critical value.
///
///   - criticalValue: A function mapping the level (see ``HypothesisTest/test(on:atLevel:)``) and the sample data
///   to the test's critical value. If the test statistic exceeds this value, the null hypothesis is rejected. In some tests, such as the
///   ``WaldTest``, the `criticalValue` depends only on the level and ignores the sample data.
///
///   - pValue: A function mapping the dataset to the reported p-value. ``HypothesisTest/pValue(for:)`` wraps this closure.
///
/// Use this function to create a custom single-purpose hypothesis test that doesn't have test parameters. To create a custom *type* of
/// hypothesis test, declare a structure conforming to ``HypothesisTest`` instead of using this function.
public func createHypothesisTest<Sample>(
    testStatistic: @escaping (Sample) -> Double,
    criticalValue: @escaping (ProbabilityOfTypeIError, Sample) -> Double,
    pValue:        @escaping (Sample) -> ProbabilityOfTypeIError
) -> some HypothesisTest {
    AnyHypothesisTest(testStatistic, criticalValue, pValue)
}

/// Type-erased HypothesisTest. Solely used as the hidden return type of `createHypothesisTest`.
fileprivate struct AnyHypothesisTest<Sample>: HypothesisTest {
    let testStatisticClosure: (Sample) -> Double
    let criticalValueClosure: (ProbabilityOfTypeIError, Sample) -> Double
    let pValueClosure:        (Sample) -> ProbabilityOfTypeIError
    
    init(
        _ testStatisticClosure: @escaping (Sample) -> Double,
        _ criticalValueClosure: @escaping (ProbabilityOfTypeIError, Sample) -> Double,
        _ pValueClosure:        @escaping (Sample) -> ProbabilityOfTypeIError
    ) {
        self.testStatisticClosure = testStatisticClosure
        self.criticalValueClosure = criticalValueClosure
        self.pValueClosure = pValueClosure
    }
    
    func testStatistic(_ data: Sample) -> Double {
        testStatisticClosure(data)
    }
    
    func criticalValue(at level: ProbabilityOfTypeIError, for data: Sample) -> Double {
        criticalValueClosure(level, data)
    }
    
    func pValue(for data: Sample) -> ProbabilityOfTypeIError {
        pValueClosure(data)
    }
}
