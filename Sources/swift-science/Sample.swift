//
//  Sample.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

extension ProbabilityDistribution where RealType.RawSignificand: FixedWidthInteger {
    func sample() -> Value {
        quantile(.random(in: 0...1))
    }
    
    func sample(count: Int) -> [Value] {
        (1...count).map { _ in sample() }
    }
}
