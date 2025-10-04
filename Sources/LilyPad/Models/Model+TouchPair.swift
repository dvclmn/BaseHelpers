//
//  Model+PointPair.swift
//  LilyPad
//
//  Created by Dave Coleman on 11/5/2025.
//

import BaseHelpers
import SwiftUI

//public struct TouchPair: Sendable, Hashable {
//  public let first: MappedTouchPoint
//  public let second: MappedTouchPoint
//
//  public init(
//    first: MappedTouchPoint,
//    second: MappedTouchPoint,
//  ) {
//    self.first = first
//    self.second = second
//  }
//
//  public init?(_ touches: [MappedTouchPoint], strictReferencePair: TouchPair) {
//    guard touches.count == 2 else { return nil }
//    
//    let lookup = Dictionary(uniqueKeysWithValues: touches.map { ($0.id, $0) })
//    
//    guard let first = lookup[strictReferencePair.first.id],
//          let second = lookup[strictReferencePair.second.id] else {
//      return nil
//    }
//    
//    self.first = first
//    self.second = second
//  }
//}
//
//extension TouchPair {
//  
//  public static func timestampSortedTouches(
//    _ touches: [MappedTouchPoint],
//  ) -> TouchPair {
//    
//    let sorted = touches.sorted {
//      $0.timestamp == $1.timestamp ? $0.id < $1.id : $0.timestamp < $1.timestamp
//    }
//    return TouchPair(first: sorted[0], second: sorted[1])
//  }
//
//  var p1: CGPoint {
//    first.position
//  }
//
//  var p2: CGPoint {
//    second.position
//  }
//
//  public var midPointBetween: CGPoint {
//    return CGPoint.midPoint(from: p1, to: p1)
//  }
//  public var distanceBetween: CGFloat {
//    return p1.distance(to: p2)
//  }
//  /// Angle in radians, from p1 to p2, in range [-π, π]
//  public var angleBetween: Angle {
//    CGPoint.angle(from: p1, to: p2)
//  }
//
//  public var angleInRadiansBetween: CGFloat {
//    CGPoint.angleInRadians(from: p1, to: p2)
//  }
//  
//  func distance(to other: TouchPair) -> CGFloat {
//    self.midPointBetween.distance(to: other.midPointBetween)
//  }
//
//}
//
//extension TouchPair: CustomStringConvertible {
//  public var description: String {
//    let firstDesc = TouchPoint.generateDescription(for: self.first)
//    let secondDesc = TouchPoint.generateDescription(for: self.second)
//    return """
//    
//    
//    First Point: \(firstDesc)
//    
//    Second Point: \(secondDesc)
//    
//    
//    """
//  }
//}
