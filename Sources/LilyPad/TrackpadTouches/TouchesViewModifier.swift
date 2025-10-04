//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

//public typealias TouchesModifierOutput = (TouchEventData?) -> Void
//public typealias TouchesModifierOutput = (Set<TouchPoint>) -> Void

public struct TrackpadTouchesModifier: ViewModifier {

  @State private var localMappedTouches: Set<TouchPoint> = []
//  @State private var localMappedTouches: Set<MappedTouchPoint> = []

  let isEnabled: Bool
  let mapStrategy: TrackpadMapStrategy
  let shouldShowIndicators: Bool
  let touchUpdates: TouchOutput

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      content
      if shouldShowIndicators {
        TouchIndicatorsView(
          mappedTouches: localMappedTouches.toArray,
          mappingStrategy: mapStrategy,
          containerSize: proxy.size,
        )
      }
      if isEnabled {
        TrackpadTouchesView(//          shouldUseVelocity: true
        ) { touchOutput in

          if shouldShowIndicators {
            //            let touches = eventData?.touches ?? []
            /// Handle touches for local views
            let mappedTouchBuilder = MappedTouchPointsBuilder(
              touches: touchOutput,
              in: mapStrategy.size(for: proxy.size)
            )
            let mapped = mappedTouchBuilder.mappedTouches
            self.localMappedTouches = mapped
          }

          touchUpdates(touchOutput)

          /// Handle touches for View using the modifier
          //          touchUpdates(touches)
        }  // touches view
        .background(.cyan.opacity(0.1))
      }  // END isEnabled check
    }  // END geo reader
  }
}
extension View {

  public func touches(
    isEnabled: Bool = true,
    mapStrategy: TrackpadMapStrategy,
    showIndicators: Bool = true,
    touchUpdates: @escaping TouchOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        isEnabled: isEnabled,
        mapStrategy: mapStrategy,
        shouldShowIndicators: showIndicators,
        touchUpdates: touchUpdates
      )
    )
  }
}
