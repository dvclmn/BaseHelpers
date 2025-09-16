//
//  FrameDimensions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

/// This is essentially equivalent to `CGSize`, but with optional
/// values, to pair nicely with SwiftUI's `.frame()` modifier.
/// I think `.frame()` lets you fall back to the layout system's
/// proposed frame size (for that dimenion) when you pass
/// in an optional value.
public struct FrameDimensions: Sendable {
  public var width: CGFloat?
  public var height: CGFloat?
  public var alignment: Alignment
  
  public static let `default` = FrameDimensions()

  public init(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    alignment: Alignment = .center
  ) {
    self.width = width
    self.height = height
    self.alignment = alignment
  }
  
  public init(
    fromSize size: CGSize,
//    width: CGFloat? = nil,
//    height: CGFloat? = nil,
    alignment: Alignment = .center
  ) {
    self.width = size.width
    self.height = size.height
    self.alignment = alignment
  }
}

extension FrameDimensions {
  public var toCGSize: CGSize? {
    guard let width, let height else { return nil }
    return CGSize(width: width, height: height)
  }
}

extension FrameDimensions: CustomStringConvertible {
  public var description: String {
    return "FrameDimensions[W: \(width?.displayString ?? "nil"), H: \(height?.displayString ?? "nil"), Alignment: \(alignment.displayName.abbreviated)]"
  }
}

