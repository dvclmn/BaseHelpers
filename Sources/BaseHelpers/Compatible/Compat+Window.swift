//
//  Compat+Window.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/9/2025.
//

import SwiftUI

/// Can't have a conditional flow for `@SceneBuilder`
//extension View {
//  @SceneBuilder
//  public func defaultLaunchBehaviorCompatible(_ behaviour: SceneLaunchBehaviorCompatible) -> some Scene {
//    if #available(macOS 15.0, iOS 18.0, *) {
//      self.defaultLaunchBehavior(behaviour.launchBehavior)
//    } else {
//      self
//    }
//  }
//}
//
//public enum SceneLaunchBehaviorCompatible: Sendable {
//  case automatic
//  case presented
//  case suppressed
//
//  @available(macOS 15.0, *)
//  var launchBehavior: SceneLaunchBehavior {
//    switch self {
//      case .automatic: .automatic
//      case .presented: .presented
//      case .suppressed: .suppressed
//    }
//  }
//}
