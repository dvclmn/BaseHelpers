//
//  FrameDimensions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

public struct FrameDimensions {
  public var width: CGFloat?
  public var height: CGFloat?
  public var alignment: Alignment

  public init(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    alignment: Alignment = .center
  ) {
    self.width = width
    self.height = height
    self.alignment = alignment
  }

//  public init(
//    _ width: CGFloat?,
//    _ height: CGFloat?,
//    alignment: Alignment = .center
//  ) {
//    self.init(
//      width: width,
//      height: height,
//      alignment: alignment
//    )
//  }
}

public enum OpposingDimensionLength {
  case infinite
  case zero
  case `nil`

  public var value: CGFloat? {
    switch self {
      case .infinite: CGFloat.infinity
      case .zero: CGFloat.zero
      case .nil: nil
    }
  }
}
