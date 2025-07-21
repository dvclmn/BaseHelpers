//
//  GraphicsContext.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

public enum DebugPoint {
  case none
  case point(Color = .orange)

  var colourForPoint: Color? {
    switch self {
      case .point(let colour):
        return colour
      case .none:
        return nil
    }
  }
}

public enum DebugTextPosition {
  case aboveOrigin
  case belowOrigin

  var multiplierForYPosition: CGFloat {
    switch self {
      case .aboveOrigin:
        return 1
      case .belowOrigin:
        return -1
    }
  }
}

extension GraphicsContext {

  // MARK: - Quick Text Label, w/ Background and Dot
  /// Note: This relies on the zoom level passed to `zoomPercent` being already
  /// normalised / expressed as a percentage. Aka range-indepedant.
  ///
  /// Otherwise changing the zoom range in the caller domain will have
  /// unintended effects on font size calculations
  public func drawDebugText(
    _ text: String,
    at point: CGPoint,
    positioned debugTextPosition: DebugTextPosition = .aboveOrigin,
    colour: Color = .primary,
    fontSize: CGFloat = 11,
    pointDisplay: DebugPoint,
    zoomPercent zoomLevel: CGFloat?  // Pass in normalised zoom if relevant
  ) {

    let zoom = zoomLevel ?? 1.0
    let fontSizeUnZoomed = fontSize.removingZoomPercent(zoom)
    //    let fontSizeUnZoomed = fontSize.removingZoom(zoom)

    /// Calculate size, for drawing Label background
    let labelWidthUnZoomed: CGFloat = {
      let approximateCharacterWidth: CGFloat = fontSize * 0.7
      let labelCharacterWidth = CGFloat(text.firstLine.count) * approximateCharacterWidth
      return labelCharacterWidth.removingZoomPercent(zoom)
    }()
    let labelHeightUnZoomed: CGFloat = fontSizeUnZoomed * 1.5
    let labelSize = CGSize(width: labelWidthUnZoomed, height: labelHeightUnZoomed)

    /// Set up Text, with basic styles
    let text = Text(text)
      .font(.system(size: fontSizeUnZoomed, weight: .semibold))
      .foregroundStyle(colour)

    let labelRect = CGRect(
      origin: point.centredIn(size: labelSize).shifted(
        dx: 0, dy: (labelHeightUnZoomed * 1.2) * debugTextPosition.multiplierForYPosition),
      size: labelSize
    )
    self.fill(labelRect.path, with: .color(Swatch.plum40.colour))
    self.draw(text, at: labelRect.midpoint)

    /// Draw dot at provided point, if needed
    if let pointColour = pointDisplay.colourForPoint {
      self.drawCircleCentred(at: point, colour: pointColour)
    }
  }

  // MARK: - Centered Circle
  public func drawCircleCentred(
    at origin: CGPoint,
    size: CGFloat = 6,
    colour: Color = .blue
  ) {
    //    let circleOrigin = origin.aligned(to: .center, in: CGSize(fromLength: size))
    let circleOrigin = origin.shifted(by: -(size / 2))
    let circleRect = CGRect(origin: circleOrigin, size: CGSize(fromLength: size))
    self.fill(.init(ellipseIn: circleRect), with: .color(colour))
  }

  // MARK: - Quick Fill and Stroke
  public func fillAndStroke(
    _ path: Path,
    fillColour: Color,
    strokeColour: Color,
    strokeThickness: CGFloat = 1
  ) {

    self.fill(
      path,
      with: .color(fillColour)
    )
    self.stroke(
      path,
      with: .color(strokeColour),
      lineWidth: strokeThickness
    )
  }

  // MARK: - Patterns
  public func drawPattern(
    _ pattern: PatternStyle,
    config: PatternConfiguration = .default,
    in size: CGSize
  ) {
    switch pattern {
      case .checkerboard:
        return drawCheckerboard(
          config: config,
          size: size
        )
      case .chevron:
        return drawChevron(
          config: config,
          size: size
        )

      case .stitches:
        return drawStitches(
          config: config,
          size: size
        )

      case .waves:
        return drawWaves(
          config: config,
          size: size
        )

      case .stripes:
        return drawStripes(
          config: config,
          size: size
        )

    }
  }

}

public struct GraphicContextPresetsView: View {

  @State private var selectedPreset: PatternStyle = .stitches

  public var body: some View {

    Canvas { context, size in
      context.drawPattern(selectedPreset, in: size)
    }
    .background(.blue.quinary)
    //    .toolbar {
    //      ToolbarItem {
    //        Picker("Patterns", selection: $selectedPreset) {
    //          Text("Checkerboard").tag(PatternStyle.checkerboard)
    //          Text("Waves").tag(PatternStyle.waves)
    ////          ForEach(PatternStyle.allCases, id: \.self) { pattern in
    ////            Text(pattern.name).tag(pattern)
    ////          }
    //        }
    //        .pickerStyle(.segmented)
    //      }
    //    }

  }
}
#if DEBUG
#Preview {
  GraphicContextPresetsView()
}
#endif
