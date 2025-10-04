//
//  IndicatorsView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

public struct TouchIndicatorsView: View {

  let mappedTouches: [TouchPoint]
  //  let touches: [MappedTouchPoint]
  let mappingStrategy: TrackpadMapStrategy
  let containerSize: CGSize
  let indicatorDiameter: CGFloat = 40

  public init(
    mappedTouches: [TouchPoint],
    mappingStrategy: TrackpadMapStrategy,
    //    mappingSize: CGSize,
    containerSize: CGSize,
  ) {
    //    if isPreview {
    //      let mapped = MappedTouchPoint.examplePoints(mappingRect: mappingRect)
    //      self.touches = mapped
    //    } else {
    self.mappedTouches = mappedTouches
    //    }
    self.mappingStrategy = mappingStrategy
    self.containerSize = containerSize
  }

  public var body: some View {

    if mappedTouches.count > 0 {
      ForEach(mappedTouches) { touch in
        Circle()
          .fill(indicatorColour(touch))
          .frame(width: indicatorDiameter)
          .overlay(alignment: .bottom) {
            /// Displays info above each individual touch location
            TouchLabel(touch)
          }
          .position(touch.position)
      }
      //      .angledLine(between: touches, mappingRect: mappingRect)
      .frame(
        width: mappingStrategy.size(for: containerSize).width,
        height: mappingStrategy.size(for: containerSize).height
      )
      .position(containerSize.midpoint)
    }

  }
}

extension TouchIndicatorsView {

  @ViewBuilder
  func TouchLabel(_ touch: TouchPoint) -> some View {
    //  func TouchLabel(_ touch: MappedTouchPoint) -> some View {
    HStack {
      Text(touch.position.displayString)
      Text("\nPhase: " + touch.phase.rawValue)
      //      if isDuplicateID(touch) {
      //        Text("\nDuplicate ID")
      //          .foregroundStyle(.red)
      //          .fontWeight(.bold)
      //      }
    }
    .monospaced()
    .font(.caption2)
    .fixedSize()
    //    .quickBackground()
    //    .quickBackground(padding: Styles.sizeNano, colour: AnyShapeStyle(.black.opacity(0.6)))
    .offset(y: -indicatorDiameter * 1.15)
  }

  func isDuplicateID(_ touch: TouchPoint) -> Bool {
    //  func isDuplicateID(_ touch: MappedTouchPoint) -> Bool {
    let matchingIdsCount =
      mappedTouches.filter { point in
        point.id == touch.id
      }
      .count

    /// If there's more than 1 point with this ID (including this one), return true
    return matchingIdsCount > 1
  }

  func indicatorColour(_ touch: TouchPoint) -> Color {
    //  func indicatorColour(_ touch: MappedTouchPoint) -> Color {
    isDuplicateID(touch) ? Color.red : Color.blue.opacity(0.7)
  }

  func touchPosition(_ touch: TouchPoint) -> CGPoint {
    //  func touchPosition(_ touch: MappedTouchPoint) -> CGPoint {
    touch.position.mapped(to: mappingStrategy.size(for: containerSize).toCGRectZeroOrigin)
  }
}
