//
//  Binding.swift
//  Collection
//
//  Created by Dave Coleman on 1/11/2024.
//

import SwiftUI

public extension Binding where Value == CGFloat {
  /// Convert `CGFloat` Binding to `Double` Binding
  var asBoundDouble: Binding<Double> {
    Binding<Double>(
      get: { Double(wrappedValue) },
      set: { wrappedValue = CGFloat($0) }
    )
  }
}

public extension Binding where Value == Double {
  /// Convert `Double` Binding to `CGFloat` Binding
  var asBoundCGFloat: Binding<CGFloat> {
    Binding<CGFloat>(
      get: { CGFloat(wrappedValue) },
      set: { wrappedValue = Double($0) }
    )
  }
}

public extension Binding where Value == Int {
  /// Convert `Int` Binding to `Double` Binding
  var asBoundDouble: Binding<Double> {
    Binding<Double>(
      get: { Double(wrappedValue) },
      set: { wrappedValue = Int($0) }
    )
  }
}


//public extension Binding {
//  
//  static func convert<TInt, TFloat>(_ intBinding: Binding<TInt>) -> Binding<TFloat>
//  where TInt: BinaryInteger & Sendable,
//        TFloat: BinaryFloatingPoint, TFloat.Stride: BinaryFloatingPoint {
//          
//          Binding<TFloat> (
//            get: { TFloat(intBinding.wrappedValue) },
//            set: { intBinding.wrappedValue = TInt($0) }
//          )
//        }
//  
//  static func convert<TFloat, TInt>(_ floatBinding: Binding<TFloat>) -> Binding<TInt>
//  where TFloat: BinaryFloatingPoint & Sendable,
//        TFloat.Stride: BinaryFloatingPoint,
//        TInt: BinaryInteger {
//          
//          Binding<TInt> (
//            get: { TInt(floatBinding.wrappedValue) },
//            set: { floatBinding.wrappedValue = TFloat($0) }
//          )
//        }
//}

