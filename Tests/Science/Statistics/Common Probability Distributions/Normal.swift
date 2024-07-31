//
//  Normal.swift
//  
//
//  Created by Lucca de Mello on 2024-06-22.
//

import Science
import Testing

@Suite
struct NormalDistributionTests {
    func randomMean()  -> Double { .random(in: -1E6...1E6) }
    func randomStdev() -> Double { .random(in: 1...10) }
    
    @Test("Verify trivial statistics of a random normal distribution")
    func trivialStatistics() {
        let normal = NormalDistribution(mean: randomMean(), standardDeviation: randomStdev())

        #expect(normal.probability(ofLessThan: .infinity) == 1)
        #expect(normal.median == normal.mean)
    }
    
    @Test("Any normal distribution with zero mean has symmetric density")
    func centeredNormalDistributionIsSymmetric() {
        let normal = NormalDistribution(mean: 0, standardDeviation: randomStdev())
        
        #expect(normal.probability(ofAtMost: 0) == 0.5)
        
        let value: Double = .random(in: -1E10...1E10)
        #expect(normal.probabilityDensity(at: value) == normal.probabilityDensity(at: -value))
    }
    
    // In any normal distribution, a value has a 68% probability of falling within 1 standard
    // deviation from the mean. Similarly for 95% and 2 standard deviations, and 98% and 3 standard deviations.
    @Test("68–95–99 rule")
    func test68_95_99Rule() {
        let mean = randomMean()
        let stdev = randomStdev()

        let normal = NormalDistribution(mean: mean, standardDeviation: stdev)

        #expect(normal.probability(ofWithin:     stdev, from: mean).isApproximatelyEqual(to: 0.68, relativeTolerance: 0.01))
        #expect(normal.probability(ofWithin: 2 * stdev, from: mean).isApproximatelyEqual(to: 0.95, relativeTolerance: 0.01))
        #expect(normal.probability(ofWithin: 3 * stdev, from: mean).isApproximatelyEqual(to: 0.99, relativeTolerance: 0.01))
    }

    @Suite
    struct DensityAtOne {
        let expectedExact: Double = 0.24197072451914335
        let expectedWhenCalculated: Double = 1 / .sqrt(2 * .exp(1) * .pi)
        let actual: Double = NormalDistribution.standard.probabilityDensity(at: 1)
        
        @Test func densityAtOneIsApproximatelyCorrect() {
            #expect(actual.isApproximatelyEqual(to: expectedExact))
            #expect(actual != expectedExact)
        }

        @Test func densityAtOneExactlyEqualsImpreciseCalculationValue() {
            #expect(actual == expectedWhenCalculated)
        }

        @Test func singlePrecisionNormalDistributionIsAsImpreciseAsExpected() {
            let impreciseNormal = NormalDistribution(over: Float.self, mean: 0, variance: 1)
            let expectedWhenCalculated: Float = 1 / .sqrt(2 * .exp(1) * .pi)
            #expect(impreciseNormal.probabilityDensity(at: 1) != expectedWhenCalculated)
        }
    }
    
    @Suite("Tests of the standard normal moment-generating function")
    struct MGFTests {
        let normal = NormalDistribution.standard
        
        @Test func exactlyCorrectAtZero() {
            #expect(normal.momentGeneratingFunction(0) == 1)
        }
        
        @Test(arguments: zip(
            // Expected MGF values generated using Mathematica:
            // > In:  Table[N[Expectation[Exp[x t], x \[Distributed] NormalDistribution[]]], {t, 1, 5}]
            // > Out: {1.64872, 7.38906, 90.0171, 2980.96, 268337.}
            [1,       2,       3,       4,        5],
            [1.64872, 7.38906, 90.0171, 2_980.96, 268_337])
        ) 
        func approximatelyCorrect(input: Int, expected: Double) {
            // Tolerate *slightly* more floating-point imprecision for larger MGF inputs.
            let tolerance = input < 5 ? 1E-6 : 1E-5
            
            #expect(normal.momentGeneratingFunction(input).isApproximatelyEqual(to: expected, relativeTolerance: tolerance))
        }
    }
}
