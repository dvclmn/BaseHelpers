//
//  Model+Transform.swift
//  BaseComponents
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

public struct CanvasTransform: Equatable, Sendable {
  public var zoom: CGFloat
  public var pan: CGSize
  public var rotation: Angle

  public static let identity = CanvasTransform()

  public init(
    zoom: CGFloat = 1.0,
    pan: CGSize = .zero,
    rotation: Angle = .zero
  ) {
    self.zoom = zoom
    self.pan = pan
    self.rotation = rotation
  }
}

extension CanvasTransform {

  /// Zoom to 100%
  public mutating func reset(_ transformations: TransformTypes = .all) {
    if transformations.contains(.zoom) {
      zoom = 1.0
    }
    if transformations.contains(.pan) {
      pan = .zero
    }
    if transformations.contains(.rotation) {
      rotation = .zero
    }
  }
  
  

  //  mutating func zoomToFit(size: CGSize) {
  //    let padding: CGFloat = 40
  //
  //  }

//  var asAffineTransform: CGAffineTransform {
//    CGAffineTransform.identity
//      .translatedBy(x: pan.width, y: pan.height)
//      .rotated(by: rotation.radians)
//      .scaledBy(x: zoom, y: zoom)
//  }

}

public struct TransformTypes: OptionSet, Sendable {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int

  public static let pan = Self(rawValue: 1 << 0)
  public static let zoom = Self(rawValue: 1 << 1)
  public static let rotation = Self(rawValue: 1 << 2)
  public static let all: Self = [.pan, .zoom, .rotation]
}

