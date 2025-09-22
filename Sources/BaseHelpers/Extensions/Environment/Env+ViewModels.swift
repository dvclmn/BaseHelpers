//
//  Env+ViewModels.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/9/2025.
//

import SwiftUI

extension EnvironmentValues {
  
  @Entry public var viewModes: ViewModes = []
  
  /// Below are aliases for `viewModes.contains(.debug)`.
  /// Prefer `viewModes` for new code.
  //  @Entry public var isDebugMode: Bool = false
  @Entry public var isEmphasised: Bool = false
  
  /// Note: `isCompactMode` is handy to have, for basic on/off
  /// declaration, but at times more granular view sizing control is needed,
  /// so prefer use of native `controlSize` in those cases/
  @Entry public var isCompactMode: Bool = false
  
  public var isDebugMode: Bool {
    get {
      let value = viewModes.contains(.debug)
      print("Reading current `isDebugMode`. Unsure if this will work as expected. Current value: \(value)")
      return value
    }
    set {
      if newValue {
        print("Setting debug mode. Unsure if this will work as expected. Current value(s): \(viewModes). New value: \(newValue)")
        viewModes.insert(.debug)
        print("Result of insertion: \(viewModes)")
      } else {
        print("I guess the new `isDebugMode` value is `false`? \(newValue). Removing from viewModes: \(viewModes)")
        viewModes.remove(.debug)
        print("Result of removal: \(viewModes)")
      }
    }
  }
}
