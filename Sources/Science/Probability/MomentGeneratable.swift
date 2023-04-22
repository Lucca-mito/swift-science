//
//  MomentGeneratable.swift
//  
//
//  Created by Lucca de Mello on 4/22/23.
//

protocol MomentGeneratable: DistributionWithVariance {
    func momentGeneratingFunction(_ t: Int) -> Statistic
    
    var skewness: Statistic { get }
    
    // TODO: Add kurtosis.
}
