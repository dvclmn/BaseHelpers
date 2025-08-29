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

public struct GridLineConfiguration {
  let columns: Int
  let rows: Int
  let cellSize: CGSize
  let colour: Color
  let strokeThickness: CGFloat

  public init(
    columnCount: Int,
    rowCount: Int,
    cellSize: CGSize,
    colour: Color = .gray.opacity(0.4),
    strokeThickness: CGFloat = 1.0,
  ) {
    self.columns = columnCount
    self.rows = rowCount
    self.cellSize = cellSize
    self.colour = colour
    self.strokeThickness = strokeThickness
  }
}

extension GraphicsContext {

  public func drawGridLines(
    config: GridLineConfiguration,
    containerSize: CGSize,
  ) {
    let zoom = self.environment.canvasZoom
    let path = Path.createGrid(
      columns: config.columns,
      rows: config.rows,
      cellSize: config.cellSize.addingZoom(zoom),
      containerSize: containerSize
    )
    self.stroke(path, with: .color(config.colour), lineWidth: config.strokeThickness)
  }

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
    self.fill(labelRect.path, with: .color(Swatch.plumGrey40.swiftUIColour))
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
    fillColour: Color = .blue.lowOpacity,
    strokeColour: Color = .indigo,
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

  public func drawHorizonLine(
    in size: CGSize,
    colour: Color = .gray,
    strokeStyle: StrokeStyle? = nil,
    strokeWidth: CGFloat = 2
  ) {

    let stroke = strokeStyle ?? StrokeStyle.dashed(strokeWidth: strokeWidth)
    let rect = CGRect(origin: .zero, size: size)
    let midY = rect.midY
    let baselinePath = Path { p in
      p.move(to: CGPoint(x: rect.minX, y: midY))
      p.addLine(to: CGPoint(x: rect.maxX, y: midY))
    }
    self.stroke(
      baselinePath,
      with: .color(colour),
      style: stroke
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

  // MARK: - Dashed Stroke
  public func dashedStroke(
    _ path: Path,
    colour: Color,
    strokeWidth: CGFloat,
    style: StrokeDashStyle = .dots,
    gap: CGFloat = 3,
  ) {
    self.stroke(
      path,
      with: .color(colour),
      style: StrokeStyle.dashed(strokeWidth: strokeWidth, style: style, gap: gap)
    )
  }
}

public enum StrokeDashStyle {
  case dots
  case dashes(length: CGFloat)

  public var dashLength: CGFloat {
    switch self {
        /// Zero allows correct behaviour for `dash: [CGFloat]`
      case .dots: .zero
      case .dashes(let length): length
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
