//
//  Model+Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

//import AppKit
//import BaseHelpers
//
//public enum GestureType: String, Sendable {
//  case pan
//  case zoom
//  case rotate
//
//  init?(
//    currentTouchPair: TouchPair,
//    initialPair: TouchPair
//  ) {
//
//    /// Movement across the screen. Used to detect panning
//    let translationThreshold: CGFloat = 10
//
//    /// Distance between fingers. Are we zooming?
//    let distanceThreshold: CGFloat = 14
//
//    /// Change in rotation of line drawn between fingers
//    /// Experiment with values between `π/12 (~15°)` and `π/8 (~22.5°)`
//    let rotationThreshold: CGFloat = .pi / 6
//
//
////    var sampler = GestureSampler()
////    
////    // On each frame:
////    sampler.ingest(currentTouchPair)
////    
////    // Later, when deciding:
////    if sampler.totalRotation > rotationThreshold {
////      self = .rotate
////    } else if sampler.totalPinchDelta > distanceThreshold {
////      self = .zoom
////    } else if sampler.totalTranslation > translationThreshold {
////      self = .pan
////    } else {
////      self = .none
////    }
//    
//    let deltaTranslation: CGFloat = Self.translationDistance(
//      from: initialPair,
//      to: currentTouchPair
//    )
////    print("Translation Delta: \(deltaTranslation.displayString)")
//
//    let deltaPinchDistance: CGFloat = abs(currentTouchPair.distanceBetween - initialPair.distanceBetween)
////    print("Pinch-Distance Delta: \(deltaPinchDistance.displayString)")
//
//    let currentAngleBetween = currentTouchPair.angleInRadiansBetween
//    let initialAngleBetween = initialPair.angleInRadiansBetween
////
//////    let deltaAngle = abs(currentAngleBetween - initialAngleBetween)
//////    let adjustedDelta = min(deltaAngle, 2 * .pi - deltaAngle)
//////    let finalAngleDelta = adjustedDelta
////    
////    // FIXED: Proper angle delta calculation
////    var deltaAngle = currentAngleBetween - initialAngleBetween
////    
////    // Normalize the angle difference to [-π, π] range
////    while deltaAngle > .pi {
////      deltaAngle -= 2 * .pi
////    }
////    while deltaAngle < -.pi {
////      deltaAngle += 2 * .pi
////    }
//
//    let finalAngleDelta = CGFloat.angleDelta(currentAngleBetween, initialAngleBetween)
//    
////    let finalAngleDelta = abs(deltaAngle)
//    
////    print(
////    """
////    
////    /// Angles ///
////    Rotation Threshold: \(rotationThreshold.toDegrees.displayString)
////    Current Pair Angle Between: \(currentAngleBetween.toDegrees.displayString)
////    Initial Pair Angle Between: \(initialAngleBetween.toDegrees.displayString)
////    Raw Delta: \((currentAngleBetween - initialAngleBetween).toDegrees.displayString)
////    Final Angle Delta: \(finalAngleDelta.toDegrees.displayString)
////    // END Angles ///
////    
////    
////    """)
////    
//    let panPassed: Bool = deltaTranslation > translationThreshold
//    let zoomPassed: Bool = deltaPinchDistance > distanceThreshold
//    let rotatePassed: Bool = finalAngleDelta > rotationThreshold
//
//    if panPassed {
//      self = .pan
//
//    } else if zoomPassed {
//      self = .zoom
//
//    } else if rotatePassed {
//      self = .rotate
//
//    } else {
//      return nil
//    }
//  }
//
//  private static func translationDistance(
//    from initialPair: TouchPair,
//    to currentPair: TouchPair,
//  ) -> CGFloat {
//    let midpointInitial: CGPoint = initialPair.midPointBetween
//    let midpointCurrent: CGPoint = currentPair.midPointBetween
//
//    let distance = midpointInitial.distance(to: midpointCurrent)
//    return distance
//  }
//}
//
//enum GestureError: Error, LocalizedError {
//  case touchesNotEqualToTwo
//  case touchIDsChanged
//}
