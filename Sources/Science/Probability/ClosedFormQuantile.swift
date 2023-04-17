//
//  ClosedFormQuantile.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

/// A probability distribution whose quantile function is closed-form.
public protocol ClosedFormQuantile: ClosedFormMedian, Samplable {
    func quantile(_ quantileFraction: RealType) -> Value
}

// MARK: - ClosedFormMedian conformance.
extension ClosedFormQuantile {
    public var median: Value { quantile(1/2) }
    
    /// A first percentile of the distribution.
    ///
    /// If there are multiple, the smallest is chosen.
    public var bottomOnePercent: Value { quantile(0.01) }
    
    /// A 99th percentile of the distribution.
    ///
    /// If there are multiple, the smallest is chosen.
    public var topOnePercent: Value { quantile(0.99) }
}

// MARK: - Samplable conformance.
// ClosedFormQuantile conforms to Samplable via inverse transform sampling.
extension ClosedFormQuantile {
    public func sample() -> Value {
        quantile(.random(in: 0...1))
    }
}
