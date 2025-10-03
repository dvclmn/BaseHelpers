//
//  Compact+IconLabelSpacing.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/9/2025.
//

import SwiftUI

extension View {
  @ViewBuilder
  public func compatibleLabelIconSpacing(_ spacing: CGFloat) -> some View {
    if #available(macOS 26, iOS 26, *) {
      labelIconToTitleSpacing(spacing)
    } else {
      self
    }
  }
}
