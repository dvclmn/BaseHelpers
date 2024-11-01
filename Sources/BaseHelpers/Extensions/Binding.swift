//
//  Binding.swift
//  Collection
//
//  Created by Dave Coleman on 1/11/2024.
//

import SwiftUI

public extension Binding {
  
  static func convert<TInt, TFloat>(_ intBinding: Binding<TInt>) -> Binding<TFloat>
  where TInt: BinaryInteger & Sendable,
        TFloat: BinaryFloatingPoint{
          
          Binding<TFloat> (
            get: { TFloat(intBinding.wrappedValue) },
            set: { intBinding.wrappedValue = TInt($0) }
          )
        }
  
  static func convert<TFloat, TInt>(_ floatBinding: Binding<TFloat>) -> Binding<TInt>
  where TFloat: BinaryFloatingPoint & Sendable,
        TInt: BinaryInteger {
          
          Binding<TInt> (
            get: { TInt(floatBinding.wrappedValue) },
            set: { floatBinding.wrappedValue = TFloat($0) }
          )
        }
}
