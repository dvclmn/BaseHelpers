//
//  Compat+Presentation.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/9/2025.
//

import SwiftUI

extension View {
  @ViewBuilder
  public func presentationSizingCompatible(_ sizing: PresentationSizingCompatible = .fitted) -> some View {
    if #available(macOS 15.0, iOS 18.0, *) {
      self.presentationSizing(sizing.sizingValue)
    } else {
      self
    }
  }

  @ViewBuilder
  public func presentationPreventsAppTerminationCompatible(_ prevents: Bool) -> some View {
    if #available(macOS 15.4, iOS 18.0, *) {
      self.presentationPreventsAppTermination(prevents)
    } else {
      self
    }
  }
}

/// See docs: ``SwiftUI/PresentationSizing``
/// Doesn't yet handle e.g. `PresentationSizing/fitted()`
/// Only static properties for now.
///
/// Note: Place any `.frame()` modifier *after* a
/// `.presentationSizingCompatible()`.
///
/// E.g.
/// ```
/// .frame(
///   minWidth: 180,
///   idealWidth: 330,
///   maxWidth: 580,
/// )
/// .presentationSizingCompatible()
///
/// ```
public enum PresentationSizingCompatible {
  case automatic
  case fitted
  case form
  case page
}

@available(macOS 15.0, iOS 18.0, *)
extension PresentationSizingCompatible {
  var sizingValue: PresentationSizing {
    switch self {
      case .automatic: .automatic
      case .fitted: .fitted
      case .form: .form
      case .page: .page
    }
  }
}
