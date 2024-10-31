//
//  CGFloat.swift
//  Collection
//
//  Created by Dave Coleman on 29/10/2024.
//

import SwiftUI

// Extension on Binding where the Value is CGFloat
public extension Binding where Value == CGFloat {
  // Convert CGFloat Binding to Double Binding
  var asDouble: Binding<Double> {
    Binding<Double>(
      get: { Double(wrappedValue) },
      set: { wrappedValue = CGFloat($0) }
    )
  }
}

// Extension on Binding where the Value is Double
public extension Binding where Value == Double {
  // Convert Double Binding to CGFloat Binding
  var asCGFloat: Binding<CGFloat> {
    Binding<CGFloat>(
      get: { CGFloat(wrappedValue) },
      set: { wrappedValue = Double($0) }
    )
  }
}
