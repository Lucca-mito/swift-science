import XCTest
@testable import swift_science

import Numerics

final class swift_scienceTests: XCTestCase {
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
        let mean = Double.random(in: -1E6 ... 1E6)
        let stdev = Double.random(in: 1...10)
        
        let normal = NormalDistribution(mean: mean, standardDeviation: stdev)
        
        XCTAssert(normal.probability(ofWithin:     stdev, from: mean).isApproximatelyEqual(to: 0.68, relativeTolerance: 0.01))
        XCTAssert(normal.probability(ofWithin: 2 * stdev, from: mean).isApproximatelyEqual(to: 0.95, relativeTolerance: 0.01))
        XCTAssert(normal.probability(ofWithin: 3 * stdev, from: mean).isApproximatelyEqual(to: 0.99, relativeTolerance: 0.01))
    }
    
    func testBernoulliDistribution() {
        let bern = BernoulliDistribution(p: Double.random(in: 0...1))
        
        XCTAssert(bern.mean == bern.p)
        XCTAssert(bern.probability(ofExactly: 0) == 1 - bern.p)
        XCTAssert(bern.probability(ofIn: [0, 1]) == 1)
    }
    
    func testMedianOfBiasedBernoulli() {
        XCTAssert(BernoulliDistribution(p: 0.4).median == 0)
        XCTAssert(BernoulliDistribution(p: 0.6).median == 1)
    }
    
    func testChoosesSmallestMedian() {
        XCTAssert(BernoulliDistribution(p: 0.5).median == 0)
    }
    
    func testSample() {
        let trials = 1_000_000
        let p = Double.random(in: 0...1)
        
        let samples = BernoulliDistribution(p: p).sample(count: trials)
        let ones = samples.reduce(0, +)
        let empirical = Double(ones) / Double(trials)
        
        XCTAssert(empirical.isApproximatelyEqual(to: p, relativeTolerance: 0.01))
    }
}
