//
//  GraphicsContext.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

public enum DebugPoint {
  case none
  case point(Color)

  var colourForPoint: Color? {
    switch self {
      case .point(let colour):
        return colour
      case .none:
        return nil
    }
  }
}

extension GraphicsContext {

  public func drawDebugText(
    _ text: String,
    at point: CGPoint,
    colour: Color = .primary,
    fontSize: CGFloat = 11,
    debugPoint: DebugPoint = .point(.orange),
    zoomLevel: CGFloat
  ) {
    //    let fontSize = CGFloat(11).removingZoom(zoomLevel)

    let fontSizeUnZoomed = fontSize.removingZoom(zoomLevel)

    let labelWidthUnZoomed: CGFloat = {
      let labelCharacterWidth = CGFloat(text.firstLine.count) * fontSize
      return labelCharacterWidth.removingZoom(zoomLevel)
    }()
    let labelHeightUnZoomed: CGFloat = fontSizeUnZoomed * 1.2
    let labelSize = CGSize(width: labelWidthUnZoomed, height: labelHeightUnZoomed)

    let text = Text(text)
      .font(.system(size: fontSizeUnZoomed, weight: .semibold))
      .foregroundStyle(colour)

    if let pointColour = debugPoint.colourForPoint {
      let pointRect = CGRect(origin: point, size: CGSize(fromLength: fontSize * 0.8))
      self.fill(.init(ellipseIn: pointRect), with: .color(pointColour))
    }

    let labelRect = CGRect(
      origin: point - (labelSize / 2),
      size: labelSize
    )
    self.fill(labelRect.path, with: .color(Swatch.plum40.colour))
    self.draw(text, at: labelRect.origin)
  }

  public func drawCircle(
    at origin: CGPoint,
    size: CGFloat = 6,
    colour: Color = .blue
  ) {
    let circleOrigin = origin.shift(by: size / 2)
    let circleRect = CGRect(origin: circleOrigin, size: CGSize(fromLength: size))
    self.fill(.init(ellipseIn: circleRect), with: .color(colour))
  }

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
