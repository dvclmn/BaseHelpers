//
//  Model+TrackpadTouch.swift
//  LilyPad
//
//  Created by Dave Coleman on 27/6/2025.
//

import CoreGraphics
import Foundation
import BaseHelpers

//public protocol TrackpadTouch: TimestampedPosition, Identifiable, Sendable, Hashable, Equatable, Codable {
//  var id: Int { get }
//  var phase: TouchPhase { get }
//  var position: CGPoint { get set }
//  var timestamp: TimeInterval { get }
//  var velocity: CGVector { get }
//  var pressure: CGFloat { get }
//  var deviceSize: CGSize { get }
//  var isResting: Bool { get }
//}

extension TouchPoint {
//extension TrackpadTouch {

  public var direction: CGFloat {
    return atan2(velocity.dy, velocity.dx)
  }

  /// Whether this touch has meaningful pressure data
  public var hasPressure: Bool {
    return pressure > 0
  }

  /// Pressure clamped between 0 and 1 for drawing operations
  public var clampedPressure: CGFloat {
    return min(max(pressure, 0), 1)
  }
}

extension Array where Element == TouchPoint {
  public var cgPoints: [CGPoint] {
    return self.map(\.position)
  }
}

extension Set where Element == TouchPoint {
  public var cgPoints: [CGPoint] {
    return self.map(\.position)
  }
}

