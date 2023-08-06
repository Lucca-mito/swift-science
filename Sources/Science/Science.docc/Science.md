# ``Science``
A scientific computing package for Swift.

<!-- The CallToAction directive does not seem to work on the landing page. -->
@Metadata {
    @DisplayName("Swift Science")
    @CallToAction(url: "https://github.com/Lucca-mito/swift-science", purpose: link, label: "View Source")
    @PageImage(
        purpose: icon,
        source: "swift-science-icon",
        alt: "A technology icon representing the Swift Science framework."
    )
}

<!-- ## Overview -->

## Topics

### Common probability distributions
- ``NormalDistribution``
- ``BernoulliDistribution``
- ``PoissonDistribution``

### Probability distribution protocols: top-level
- ``ProbabilityDistribution``
- ``Samplable``

### Probability distribution protocols: by continuity
- ``DiscreteDistribution``
- ``ContinuousDistribution``

### Probability distribution protocols: by moments
- ``DistributionWithMean``
- ``DistributionWithVariance``
- ``DistributionWithMoments``

### Probability distribution protocols: by quantiles
- ``ClosedFormMedian``
- ``ClosedFormQuantile``

### Probability distribution protocols: by modality
- ``FiniteModal``
- ``Unimodal``

### Probability distribution protocols: by boundedness
- ``LowerBoundedDistribution``
- ``BoundedDistribution``
- ``BoundedDiscreteDistribution``

### Sample statistics
- ``Science/Swift/Collection``

### Hypothesis tests
- ``HypothesisTest``
- ``WaldTest``

### Probabilities used in hypothesis testing
- ``ProbabilityOfTypeIError``
- ``Science/Swift/Double/lowProbability``
- ``Science/Swift/Double/veryLowProbability``

### Metric spaces
- ``MetricSpace``
- ``Euclidean``

### Numerical utilities
- ``IntegerApproximable``
