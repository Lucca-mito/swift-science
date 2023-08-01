//
//  Acklam.swift
//  
//
//  Created by Lucca de Mello on 2023-08-02.
//

import RealModule

// An algorithm developed by Peter John Acklam (github.com/pjacklam) for approximating the standard normal CDF.
// Adapted from https://web.archive.org/web/20151030215612/http://home.online.no/~pjacklam/notes/invnorm
// Acklam's algorithm is FOSS: "You can use the algorithm [...] for whatever purpose you want".
fileprivate func standardAcklam<Statistic>(p: Statistic) -> Statistic
where Statistic: Real & ExpressibleByFloatLiteral
{
    // Normal distributions are neither bounded below nor bounded above, so they don't have a
    // 0th quantile nor a 1st quantile.
    precondition(0 < p && p < 1)
    
    // From Acklam's Q&A section on the algorithm:
    // Q: "How did you find the coefficients?"
    // A: "The coefficients were computed by another algorithm I wrote, an iterative algorithm that
    // moves the nodes back and forth to minimize the absolute value of the relative error in the
    // rational approximation."
    
    let a: [Statistic] = [
        -3.969683028665376e+01,
         2.209460984245205e+02,
         -2.759285104469687e+02,
         1.383577518672690e+02,
         -3.066479806614716e+01,
         2.506628277459239e+00
    ]
    
    let b: [Statistic] = [
        -5.447609879822406e+01,
        1.615858368580409e+02,
        -1.556989798598866e+02,
        6.680131188771972e+01,
        -1.328068155288572e+01,
    ]
    
    let c: [Statistic] = [
        -7.784894002430293e-03,
        -3.223964580411365e-01,
        -2.400758277161838e+00,
        -2.549732539343734e+00,
        4.374664141464968e+00,
        2.938163982698783e+00
    ]
    
    let d: [Statistic] = [
        7.784695709041462e-03,
        3.224671290700398e-01,
        2.445134137142996e+00,
        3.754408661907416e+00
    ]
    
    // Define the breakpoints.
    let pLow: Statistic = 0.02425
    let pHigh = 1 - pLow
    
    // The return value is numerator / denominator
    let numerator: Statistic
    let denominator: Statistic
    
    switch p {
        
    // Approximate quantiles for the lower region.
    // The `..<` range in this case includes 0, which is not allowed (p must be positive), but this
    // has already been handled by the precondition at the start.
    case 0 ..< pLow:
        let q = Statistic.sqrt(-2 * .log(p))
        
        numerator = ((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]
        denominator = (((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1
        
    // For the central region.
    case pLow ..< pHigh:
        let q = p - 0.5
        let r = q * q
        
        numerator = ((((a[0] * r + a[1]) * r + a[2]) * r + a[3]) * r + a[4]) * r + a[5]
        
        // Breaking up the more complex expressions into sub-expressions speeds up type-checking.
        //
        // TODO: Is there a typechecking-speed-maximizing strategy for breaking up an expression?
        // For example, would typechecking this denominator be even faster if `denominatorSubexpression`
        // and `denominator` had roughly the same number of operations?
        let denominatorSubexpression = (((b[0] * r + b[1]) * r + b[2]) * r + b[3]) * r + b[4]
        denominator = denominatorSubexpression * r + 1
        
    // Upper region.
    case pHigh ..< 1:
        let q: Statistic = Statistic.sqrt(-2 * .log(1 - p))
        
        let numeratorSubexpression = (((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]
        numerator = -((numeratorSubexpression) * q + c[5])
        
        let denominatorSubexpression = ((d[0] * q + d[1]) * q + d[2]) * q + d[3]
        denominator = denominatorSubexpression * q + 1
        
    // Impossible thanks to the precondition.
    default:
        preconditionFailure()
    }
    
    return numerator /  denominator
}

/// The Acklam algorithm, generalized for any normal distribution.
internal func acklam<Statistic>(
    p: Statistic,
    standardDeviation: Statistic,
    mean: Statistic
) -> Statistic where Statistic: Real & ExpressibleByFloatLiteral
{
    standardAcklam(p: p) * standardDeviation + mean
}
