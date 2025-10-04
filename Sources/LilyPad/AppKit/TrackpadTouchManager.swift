//
//  TrackpadTouchManager.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit
import BaseHelpers

/// Manages trackpad touches and maintains their history for velocity calculations
class TrackpadTouchManager {

  public var activeTouches: Set<Int> = []

  /// Dictionary to store the last known touch for each touch ID
  private var lastTouches: [Int: TouchPoint] = [:]

  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TouchPoint]] = [:]

  //  private let mappingRect: CGRect

  /// Maximum number of touch points to keep in history per stroke
  private let maxHistoryDepth: Int
  private let velocityCalculator: VelocityCalculator

  init() {
    self.maxHistoryDepth = 8
    self.velocityCalculator = VelocityCalculator(maxHistoryDepth: maxHistoryDepth)
  }

  func processCapturedTouches(
    _ nsTouches: Set<NSTouch>,
    timestamp: TimeInterval,
    pressure: CGFloat
  ) -> Set<TouchPoint> {
    //  ) -> TouchEventData {

    var updatedTouches = Set<TouchPoint>()

    for nsTouch in nsTouches {
      let touchId = nsTouch.identity.hash
      let phase = nsTouch.phase

      /// Handle touch lifecycle
      switch phase {
        case .began, .moved:
          activeTouches.insert(touchId)

        case .ended, .cancelled:
          activeTouches.remove(touchId)

          /// Clean up after processing this touch, now that it is finished
          touchHistories.removeValue(forKey: touchId)
          lastTouches.removeValue(forKey: touchId)

        default:
          /// This is to make sure that we don't have touches
          /// being 'left on', resulting in the UI thinking there's
          /// still an active touch, which often happens
          activeTouches.remove(touchId)
      }

      /// Create raw touch point
      let rawTouch = TouchPoint(
        from: nsTouch,
        touchID: touchId,
        phase: phase,
        timestamp: timestamp,
        pressure: pressure,
        deviceSize: nsTouch.deviceSize,
        isResting: nsTouch.isResting
      )

      /// Update history
      updateTouchHistory(touchId: touchId, touchPoint: rawTouch)

      /// Compute velocity based on history
      let history: [TouchPoint] = touchHistories[touchId] ?? []
      let velocity = velocityCalculator.computeWeightedVelocity(from: history)

      /// Create final touch with computed velocity
      let enrichedTouch = rawTouch.withVelocity(velocity)
      updatedTouches.insert(enrichedTouch)
      lastTouches[touchId] = enrichedTouch

    }

    return updatedTouches
    //    let eventData = TouchEventData(touches: updatedTouches, pressure: pressure)
    //    return eventData
  }


  private func updateTouchHistory(
    touchId: Int,
    touchPoint: TouchPoint
  ) {
    var history = touchHistories[touchId] ?? []

    /// Add the newest point to this touch's history
    history.append(touchPoint)

    /// Maintain rolling window
    if history.count > maxHistoryDepth {
      history.removeFirst()
    }

    /// Update the history entry itself
    touchHistories[touchId] = history
  }

}
