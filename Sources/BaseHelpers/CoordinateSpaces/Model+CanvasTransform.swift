//
//  Model+Transform.swift
//  BaseComponents
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

public struct CanvasTransform: Equatable, Sendable {

  /// The current actual zoom scale (used in transforms)
  public var zoom: CGFloat
  public var pan: CGSize
  public var rotation: Angle

  public let zoomRange: ClosedRange<Double> = 0.1...40.0

  /// "100%" zoom level
  let baselineZoom: CGFloat = 6.0

  public static let identity = CanvasTransform()

  public init(
    zoom: CGFloat = 4.0,
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
      resetZoom()
    }
    if transformations.contains(.pan) {
      pan = .zero
    }
    if transformations.contains(.rotation) {
      rotation = .zero
    }
  }

  /// The zoom percentage (0.0 to 1.0) representing position along the zoom range (logarithmically scaled)
  public var zoomPercent: CGFloat {
    get {
      let logMin = log(zoomRange.lowerBound)
      let logMax = log(zoomRange.upperBound)
      let logLevel = log(zoom)
      return (logLevel - logMin) / (logMax - logMin)
    }
    set {
      zoom = Self.zoom(for: newValue, in: zoomRange)
    }
  }

  private mutating func resetZoom() {
    setZoomPercent(1.0)
  }

  /// Converts a 0.0...1.0 percent value to a zoom, using logarithmic scaling
  public static func zoom(
    for percent: CGFloat,
    in range: ClosedRange<Double>
  ) -> CGFloat {
    let logMin = log(range.lowerBound)
    let logMax = log(range.upperBound)
    let logValue = logMin + percent * (logMax - logMin)
    return exp(logValue)
  }

  /// Convenience for easy zoom percentage setting
  public mutating func setZoomPercent(_ percent: CGFloat) {
    self.zoom = Self.zoom(for: percent, in: self.zoomRange)

  }

  /// Converts zoom to a displayed UI percentage relative to your defined baseline
  public var displayedZoomPercent: Int {
    Int((zoom / baselineZoom) * 100.0)
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
