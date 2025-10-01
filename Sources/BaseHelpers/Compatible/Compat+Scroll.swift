//
//  Compat+Scroll.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/9/2025.
//

import SwiftUI

extension View {

  @ViewBuilder
  public func scrollEdgeEffectStyleCompatible(isSoft: Bool, for edge: Edge.Set) -> some View {
    if #available(macOS 26.0, *) {
      self.scrollEdgeEffectStyle(isSoft ? .soft : .automatic, for: edge)
    } else {
      self
    }
  }
}
