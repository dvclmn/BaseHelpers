//
//  ViewSizeModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public typealias SizeOutput = (CGSize) -> Void

public struct ViewSizeModifier: ViewModifier {
  
  let sizeOutput: SizeOutput
  
  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: CGSize.self) { proxy in
        return proxy.size
      } action: { newValue in
        sizeOutput(newValue)
      }

  }
}
public extension View {
  func viewSize(sizeOutput: @escaping SizeOutput) -> some View {
    self.modifier(ViewSizeModifier(sizeOutput: sizeOutput))
  }
}
