//
//  Strideable+Euclidean.swift
//  
//
//  Created by Lucca de Mello on 5/15/23.
//

extension Int: Euclidean {}
extension Int8: Euclidean {}
extension Int16: Euclidean {}
extension Int32: Euclidean {}
extension Int64: Euclidean {}

extension UInt: Euclidean {}
extension UInt8: Euclidean {}
extension UInt16: Euclidean {}
extension UInt32: Euclidean {}
extension UInt64: Euclidean {}

extension Float: Euclidean {}
extension Double: Euclidean {}

// TODO: Add Float16 and Float80 conformances with the appropriate availability checks.

// TODO: Pointer types should also conform to Euclidean since they conform to Stridable.
