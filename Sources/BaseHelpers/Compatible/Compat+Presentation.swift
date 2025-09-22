//
//  Compat+Presentation.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/9/2025.
//

import SwiftUI

extension View {
  @ViewBuilder
  public func resizableSheet() -> some View {
    if #available(macOS 15.0, iOS 18.0, *) {
      self.presentationSizing(.fitted)
    } else {
      self
    }
  }
}
