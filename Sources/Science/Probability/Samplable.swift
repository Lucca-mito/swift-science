//
//  Samplable.swift
//  
//
//  Created by Lucca de Mello on 4/16/23.
//

public protocol Samplable: ProbabilityDistribution {
    func sample() -> Value
}

extension Samplable {
    public func sample(count: Int) -> [Value] {
        (1...count).map { _ in sample() }
    }
}
