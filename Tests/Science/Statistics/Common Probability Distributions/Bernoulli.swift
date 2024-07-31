//
//  Bernoulli.swift
//
//
//  Created by Lucca de Mello on 2024-06-22.
//

import Science
import Testing

@Suite
struct BernoulliDistributionTests {
    @Test("Basic statistics of a random Bernoulli distribution are correct")
    func basicStatistics() {
        let bern = BernoulliDistribution(probabilityOfOne: .random(in: 0...1))

        #expect(bern.mean == bern.probabilityOfOne)
        #expect(bern.probability(ofExactly: 0) == bern.probabilityOfZero)
        #expect(bern.probability(ofIn: [0, 1]) == 1)
    }

    @Test("Median is p rounded to nearest")
    func medianRoundsToNearest() {
        #expect(BernoulliDistribution(probabilityOfOne: 0.4).median == 0)
        #expect(BernoulliDistribution(probabilityOfOne: 0.6).median == 1)
    }

    @Test("When there are 2 medians, the smallest is chosen")
    func testChoosesSmallestMedian() {
        #expect(BernoulliDistribution(probabilityOfOne: 0.5).median == 0)
    }

    @Test("Can determine p empirically by averaging many samples")
    func canDeterminePEmpirically() {
        let trials = 1_000_000
        let p = Double.random(in: 0...1)

        let samples = BernoulliDistribution(probabilityOfOne: p).sample(count: trials)
        let empirical = samples.mean()

        #expect(empirical.isApproximatelyEqual(to: p, relativeTolerance: 0.01))
    }
}
