//
//  Model+Wave.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 3/11/2024.
//

import SwiftUI
import BaseStyles

struct WaveAppearance: Documentable {
  var line: LineStyle = .init()
  var points: PointStyle = .init()
  var timeWindow: TimeWindow = .init()
}

struct LineStyle: Documentable {
  var width: Double = 2
  var mitreLimit: Double = 1
  var join: LineJoin = .round
  var interpolation: PathInterpolationConfig = .defaultConfig(for: .linear)
}

enum LineJoin: Documentable {
  case sharp
  case round
  
  var value: CGLineJoin {
    switch self {
      case .sharp: .miter
      case .round: .round
    }
  }
}

enum PathInterpolation: Documentable, CaseIterable, Identifiable {
  case linear
  case quadCurve
  case catmullRom
  
  var id: String {
    self.name
  }
  
  var name: String {
    switch self {
      case .linear:
        return "Linear"
      case .quadCurve:
        return "Quadratic"
      case .catmullRom:
        return "Catmull-Rom"
    }
  }
  
  var validParameters: WritableKeyPath<PathInterpolationConfig, Double>? {
    switch self {
      case .linear: \.miterLimit
      case .quadCurve: nil
      case .catmullRom: \.tension
    }
  }
  
}

struct PathInterpolationConfig: Documentable {
  var type: PathInterpolation
  var miterLimit: Double
  var tension: Double
  
  // Default configurations for each type
  static func defaultConfig(for type: PathInterpolation) -> PathInterpolationConfig {
    switch type {
      case .linear:
        return PathInterpolationConfig(
          type: type,
          miterLimit: 0.2,
          tension: 0  // Unused for lines
        )
      case .quadCurve:
        return PathInterpolationConfig(
          type: type,
          miterLimit: 0,  // Unused for quad curves
          tension: 0      // Unused for quad curves
        )
      case .catmullRom:
        return PathInterpolationConfig(
          type: type,
          miterLimit: 0,  // Unused for Catmull-Rom
          tension: 0.5
        )
    }
  }
  
  static let miterLimitRange: ClosedRange<CGFloat> = 0.0...1.0
  static let tensionRange: ClosedRange<CGFloat> = 0.0...1.0
  
}

struct PointStyle: Documentable {
  var size: Double = 4
  var shape: Shape = .circle
  var colour: Swatch = .green50
  var count: Double = 100
  
  var shouldCalculateSamplePointsAutomatically: Bool = true

  static let countRange: ClosedRange<Double> = 2...500
  static let sizeRange: ClosedRange<Double> = 1...120
  
  static let swatches: [Swatch] = [
    .yellow30, .purple20, .brown40
//    .yellowMuted, .purpleLavendar, .peachVibrant, .greenPewter, .blueElectric, .olive, .offWhite
  ]
  
  enum Shape: Documentable, CaseIterable {
    case none
    case circle
    case square
    case diamond
    
    var value: AnyShape? {
      switch self {
        case .none: nil
        case .circle: AnyShape(.circle)
        case .square: AnyShape(.rect)
        case .diamond: AnyShape(Diamond())
      }
    }
    
    var name: String {
      switch self {
        case .none: "None"
        case .circle: "Circle"
        case .square: "Square"
        case .diamond: "Diamond"
      }
    }
    
    var icon: String {
      switch self {
        case .none: "circle.slash"
        case .circle: "circle.fill"
        case .square: "square.fill"
        case .diamond: "diamond.fill"
      }
    }
  }
}

struct TimeWindow: Documentable {
  var length: TimeInterval = 4
  static let windowOptions: [TimeInterval] = [1, 2, 4, 8, 12, 24, 30]
  static let timeRange: ClosedRange<Double> = 1...30
}
