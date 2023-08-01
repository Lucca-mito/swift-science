//
//  DifferenceOfMeans.swift
//  
//
//  Created by Lucca de Mello on 2023-08-02.
//

extension Collection where Element == (Double, Double) {
    /// The difference between the means of two datasets.
    /// Temporary limitation: this method only supports Double precision until Swift has [parameterized extensions].
    ///
    /// [parameterized extensions]: https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md#parameterized-extensions
    ///
    /// - Precondition: The collection cannot be empty.
    ///
    /// - Returns: The difference between the mean of 𝑋 and the mean of 𝑌, where 𝑋 contains the *first* elements of each tuple in
    /// the collection and 𝑌 contains the *second* elements.
    public func differenceOfMeans() -> Double {
        precondition(!isEmpty)
        return map(\.0).mean() - map(\.1).mean()
    }
}
