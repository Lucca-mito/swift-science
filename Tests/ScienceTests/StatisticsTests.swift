import XCTest
import Science
import ComplexModule

// TODO: Many new features have been added since the last time tests were written.

final class StatisticsTests: XCTestCase {
    func testNormalDistribution() {
        let stdev: Double = .random(in: 1...10)
        let normal = NormalDistribution(mean: 0, standardDeviation: stdev)
        
        XCTAssert(normal.probability(ofAtMost: 0) == 1/2)
        XCTAssert(normal.probability(ofLessThan: .infinity) == 1)
        XCTAssert(normal.median == normal.mean)
    }
    
    func testPrecision() {
        let preciseNormal   = NormalDistribution<Double>.standard
        let impreciseNormal = NormalDistribution<Float>.standard
        
        XCTAssert(preciseNormal  .probabilityDensity(at: 1) == 1 / .sqrt(2 * .exp(1) * .pi))
        XCTAssert(impreciseNormal.probabilityDensity(at: 1) != 1 / .sqrt(2 * .exp(1) * .pi))
    }
    
    func test68_95_99Rule() {
        let mean: Double = .random(in: -1E6...1E6)
        let stdev: Double = .random(in: 1...10)
        
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
        let p: Double = .random(in: 0...1)
        
        let samples: [Int] = BernoulliDistribution(probabilityOfOne: p).sample(count: trials)
        let empirical: Double = samples.mean()
        
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
}
