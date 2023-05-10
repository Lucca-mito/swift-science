import XCTest
import Science

final class ProbabilityTests: XCTestCase {
    func testNormalDistribution() {
        let stdev = Double.random(in: 1...10)
        let normal = NormalDistribution(mean: 0, standardDeviation: stdev)
        
        XCTAssert(normal.probability(ofAtMost: 0) == 1/2)
        XCTAssert(normal.probability(ofLessThan: .infinity) == 1)
        XCTAssert(normal.median == normal.mean)
    }
    
    func testDartBoardParadox() {
        let distribution = NormalDistribution<Double>.standard
        let anyNumber = Double.random(in: -1E6...1E6)
        XCTAssert(distribution.probability(ofExactly: anyNumber) == 0)
    }
    
    func testPrecision() {
        let preciseNormal   = NormalDistribution<Double>.standard
        let impreciseNormal = NormalDistribution<Float>.standard
        
        XCTAssert(preciseNormal  .probabilityDensity(at: 1) == 1 / .sqrt(2 * .exp(1) * .pi))
        XCTAssert(impreciseNormal.probabilityDensity(at: 1) != 1 / .sqrt(2 * .exp(1) * .pi))
    }
    
    func test68_95_99Rule() {
        let mean = Double.random(in: -1E6...1E6)
        let stdev = Double.random(in: 1...10)
        
        let normal = NormalDistribution(mean: mean, standardDeviation: stdev)
        
        XCTAssert(normal.probability(ofWithin:     stdev, from: mean).isApproximatelyEqual(to: 0.68, relativeTolerance: 0.01))
        XCTAssert(normal.probability(ofWithin: 2 * stdev, from: mean).isApproximatelyEqual(to: 0.95, relativeTolerance: 0.01))
        XCTAssert(normal.probability(ofWithin: 3 * stdev, from: mean).isApproximatelyEqual(to: 0.99, relativeTolerance: 0.01))
    }
    
    func testBernoulliDistribution() {
        let bern = BernoulliDistribution<Int, Double>(probabilityOfOne: Double.random(in: 0...1))
        
        XCTAssert(bern.mean == bern.probabilityOfOne)
        XCTAssert(bern.probability(ofExactly: 0) == bern.probabilityOfZero)
        XCTAssert(bern.probability(ofIn: [0, 1]) == 1)
    }
    
    func testMedianOfBiasedBernoulli() {
        XCTAssert(BernoulliDistribution(probabilityOfOne: 0.4).median == 0)
        XCTAssert(BernoulliDistribution(probabilityOfOne: 0.6).median == 1)
    }
    
    func testChoosesSmallestMedian() {
        XCTAssert(BernoulliDistribution(probabilityOfOne: 0.5).median == 0)
    }
    
    func testSampleBernoulli() {
        let trials = 1_000_000
        let p = Double.random(in: 0...1)
        
        let samples = BernoulliDistribution<Int, Double>(probabilityOfOne: p).sample(count: trials)
        
        // TODO: Compute mean using sample statistics instead.
        let empirical = Double(samples.reduce(0, +)) / Double(trials)
        
        XCTAssert(empirical.isApproximatelyEqual(to: p, relativeTolerance: 0.01))
    }
    
    func testMomentGeneratingFunction() {
        let dist = NormalDistribution<Double>.standard
        
//      Expected values generated using Mathematica:
//      In:  Table[N[Expectation[Exp[x t], x \[Distributed] NormalDistribution[]]], {t, 0, 5}]
//      Out: {1., 1.64872, 7.38906, 90.0171, 2980.96, 268337.}
        
        XCTAssert(dist.momentGeneratingFunction(0) == 1)
        XCTAssert(dist.momentGeneratingFunction(1).isApproximatelyEqual(to: 1.64872, relativeTolerance: 1E-6))
        XCTAssert(dist.momentGeneratingFunction(2).isApproximatelyEqual(to: 7.38906, relativeTolerance: 1E-6))
        XCTAssert(dist.momentGeneratingFunction(3).isApproximatelyEqual(to: 90.0171, relativeTolerance: 1E-6))
        XCTAssert(dist.momentGeneratingFunction(4).isApproximatelyEqual(to: 2_980.96, relativeTolerance: 1E-6))
        XCTAssert(dist.momentGeneratingFunction(5).isApproximatelyEqual(to: 268_337, relativeTolerance: 1E-5))
    }
    
    func testEmpiricalMomentGeneratingFunction() {
        // This test is similar to the above, but it empirically estimates the MGF instead of using momentGeneratingFunction.
        
        XCTExpectFailure("""
        Highly numerically unstable. Also, this test should almost certainly be deleted: the failure has nothing to do with Swift Science.
        """)
        
        typealias Statistic = Double
//        typealias Statistic = Float80 // See the comment at the end of this function.
        
        let dist = NormalDistribution<Statistic>.standard
        
        let numSamples = 1_000_000
        let samples = dist.sample(count: numSamples)
        
        for t in 0...5 {
            // `momentGeneratingFunction` (and, therefore, `expected`) is accurate. See previous test.
            let expected = dist.momentGeneratingFunction(t)
            
            let t = Statistic(t)
            
            /// Samples of e^(tX) where X ~ dist
            let expOfTX: [Statistic] = samples.map { x in .exp(t * x) }
            
            // TODO: Compute mean using sample statistics instead.
            /// Empirical e^(tX)
            let actual = expOfTX.reduce(0, +) / Statistic(numSamples)
            
            print("For t = \(t): expected \(expected), got \(actual).")
            XCTAssert(actual.isApproximatelyEqual(to: expected, relativeTolerance: 0.1))
        }
        
//      Additionally, here's a weird benchmark: Float80 seems *less* accurate than Double.
//
//      With Double:
//      For t = 1.0: expected 1.6487212707001282, got 1.647103703543096.
//      For t = 2.0: expected 7.38905609893065, got 7.335719749082736.
//      For t = 3.0: expected 90.01713130052181, got 87.6014838607417.
//      For t = 4.0: expected 2,980.9579870417283, got 2,802.842879732373.
//      For t = 5.0: expected 268,337.2865208745, got 207,524.04270988415.
//
//      With Float80:
//      For t = 1.0: expected 1.6487212707001281469, got 1.649565173038897215.
//      For t = 2.0: expected 7.3890560989306502274, got 7.432225906746599147.
//      For t = 3.0: expected 90.01713130052181355, got 92.127256102237490044.
//      For t = 4.0: expected 2,980.9579870417282748, got 2,884.3578174449494709.
//      For t = 5.0: expected 268,337.28652087445695, got 172,588.52832361549311.
//      TODO: Test this with Float128 when it becomes available.
    }
}
