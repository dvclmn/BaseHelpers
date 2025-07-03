//
//  AspectRatioModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

/// Article talking about the below:
/// https://alejandromp.com/development/blog/image-aspectratio-without-frames/
public struct AspectRatioModifier: ViewModifier {

  let ratio: CGFloat
  public func body(content: Content) -> some View {
    content
      .aspectRatio(contentMode: .fill)
      .frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity
      )
      .aspectRatio(ratio, contentMode: .fit)
      .clipped()
  }
}
extension View {
  public func viewAspectRatio(_ ratio: CGFloat) -> some View {
    self.modifier(AspectRatioModifier(ratio: ratio))
  }
}
