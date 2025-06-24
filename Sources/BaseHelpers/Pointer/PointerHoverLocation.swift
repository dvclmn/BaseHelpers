//
//  PointerHoverLocation.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

public struct CanvasHoverModifier: ViewModifier {
  @Environment(\.panOffset) private var panOffset
  @Environment(\.zoomLevel) private var zoomLevel
  //  @Environment(AppHandler.self) private var store

  let isEnabled: Bool
  let mappingSize: CGSize?
  let hoverlocation: (CGPoint) -> Void

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      content
        .onContinuousHover(coordinateSpace: .local) { hoverPhase in
          /// This is important, so we're only doing the work of mapping
          /// coordinates, checking for stroke intersections etc when we need to

          guard isEnabled else { return }

          switch hoverPhase {
            case .active(let location):

              let hoveredLocation: CGPoint
              if let mappingSize {
                let remapper = PointRemapper(
                  currentSize: proxy.size,
                  targetSize: mappingSize
                )
                let mapped = remapper.remappedToTarget(
                  location,
                  zoom: zoomLevel,
                  pan: panOffset
                )
                hoveredLocation = mapped

              } else {
                hoveredLocation = location
              }
              hoverlocation(hoveredLocation)

            case .ended:
              break
          }
        }  // END hover
    }

  }
}

extension View {
  public func mappedHoverLocation(
    isEnabled: Bool = true,
    mappingSize: CGSize?,
    hoverlocation: @escaping (CGPoint) -> Void
  ) -> some View {
    self.modifier(
      CanvasHoverModifier(
        isEnabled: isEnabled,
        mappingSize: mappingSize,
        hoverlocation: hoverlocation
      )
    )
  }
}
