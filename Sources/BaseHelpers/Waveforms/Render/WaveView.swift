//
//  Waveforms.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

/// Note: it's expected that this View will be embedded in a `TimelineView`
public struct WaveView: View {

  @State private var xPositions: [CGFloat] = []
  @State private var spatialPhases: [CGFloat] = []
  @State private var horizonPath: Path = .init()
  @State private var lastComputedSize: CGSize = .zero
  @State private var lastComputedSampleCount: Int = 0

  let wave: Wave
  let elapsed: CGFloat
  let strokeWidth: CGFloat
  let sampleCount: Int
  let components: WaveComponents
  let waveViewStyle: WaveViewStyle

  public init(
    wave: Wave,
    elapsed: CGFloat,
    strokeWidth: CGFloat = 2,
    sampleCount: Int = 80,
    components: WaveComponents = [.all],
    waveViewStyle: WaveViewStyle = .standard,
  ) {
    self.wave = wave
    self.elapsed = elapsed
    self.strokeWidth = strokeWidth
    self.sampleCount = sampleCount
    self.components = components
    self.waveViewStyle = waveViewStyle
  }

  public var body: some View {

    Canvas {
      context,
      size in

      // Ensure we have valid data before proceeding
      guard size.width > 0 && size.height > 0 && sampleCount > 0 else { return }

      // Recompute static geometry only if needed
      let needsRecomputation =
        xPositions.count != sampleCount || spatialPhases.count != sampleCount || lastComputedSize != size
        || lastComputedSampleCount != sampleCount

      if needsRecomputation {
        Task { @MainActor in
          recomputeStatic(for: size)
        }
      }

      // Safety check: ensure arrays are properly initialized
      guard xPositions.count == sampleCount && spatialPhases.count == sampleCount else {
        return
      }

      // Precompute frame-specific dynamic parts
      let omega = wave.frequency.displayed * 2 * .pi
      let amp = wave.amplitude.displayed
      let phaseMain = omega * elapsed + wave.phaseOffset.displayed

      // Generate main wave points
      let mainPoints = generateWavePoints(
        amp: amp,
        phase: phaseMain,
        size: size
      )

      // Main wave line
      if components.contains(.line) {
        drawWaveLine(context: context, points: mainPoints)
      }

      // Points
      if components.contains(.points) {
        drawWavePoints(context: context, points: mainPoints)
      }

      // Ghost line
      if wave.phaseOffset.displayed > 0, components.contains(.phaseGhost) {
        drawGhostWave(context: context, mainPoints: mainPoints, size: size)
      }

      // Horizon
      context.stroke(horizonPath, with: .color(.gray.lowOpacity))

      //      //      let extraPhase: CGFloat = 0.05 // 5% of a cycle
      //
      //      /// Recompute static geometry only if sampleCount or size changes
      //      if xPositions.count != sampleCount || horizonPath.boundingRect.size != size {
      //        Task { @MainActor in
      //          recomputeStatic(for: size)
      //        }
      //      }
      //
      //      /// Precompute frame-specific dynamic parts
      //      let omega = wave.frequency.displayed * 2 * .pi
      //      let amp = wave.amplitude.displayed
      //
      //      let phaseMain = omega * elapsed + wave.phaseOffset.displayed
      //      let phaseGhost = omega * elapsed  // ghost has no offset
      //
      //      var mainPoints: [CGPoint] = []
      //      //      var ghostPoints: [CGPoint] = []
      //      mainPoints.reserveCapacity(sampleCount)
      //
      //      //      ghostPoints.reserveCapacity(sampleCount)
      //
      //      for i in 0..<sampleCount {
      //        let sp = spatialPhases[i]
      //        let x = xPositions[i]
      //        let mainY = amp * sin(phaseMain + sp)
      ////        let ghostY = amp * sin(phaseGhost + sp)
      //
      //        mainPoints.append(CGPoint(x: x, y: size.height / 2 + mainY))
      //      }
      //
      //      /// Main wave line
      //      if components.contains(.line) {
      //        var linePath = Path()
      //        linePath.addLines(mainPoints)
      //        context.stroke(linePath, with: .color(wave.colour.nativeColour), lineWidth: strokeWidth)
      //      }
      //
      //      /// Points
      //      if components.contains(.points) {
      //        let dot = Path(ellipseIn: CGRect(x: -2.5, y: -2.5, width: 5, height: 5))
      //        for p in mainPoints {
      //          context.translateBy(x: p.x, y: p.y)
      //          context.fill(dot, with: .color(.brown))
      //          context.translateBy(x: -p.x, y: -p.y)
      //        }
      //      }
      //
      //      /// Ghost line
      //      if wave.phaseOffset.displayed > 0, components.contains(.phaseGhost) {
      //
      //        let points = ghostPoints(
      //          from: mainPoints,
      //          using: spatialPhases,
      //          phaseShift: omega * elapsed + wave.phaseOffset.displayed,
      //          wave: wave
      //        )
      //
      //        var ghostPath = Path()
      //        ghostPath.addLines(points)
      //        context.stroke(
      //          ghostPath,
      //          with: .color(wave.colour.nativeColour.lowOpacity),
      //          style: .dashed(strokeWidth: strokeWidth, gap: strokeWidth / 2)
      //        )
      //      }
      //
      //      /// Horizon
      //      context.stroke(horizonPath, with: .color(.gray.lowOpacity))

      /// On size/sampleCount change → recompute static values
      //      if xPositions.count != sampleCount {
      //        Task { @MainActor in
      //          recomputeStatic(for: size)
      //        }
      //      }

      //      let rect = CGRect(origin: .zero, size: size)
      //      /// Per tick: compute Y values
      ////      let points = xPositions.map { x -> CGPoint in
      ////        let y = wave.valueAt(
      ////          x: x,
      ////          in: ,
      ////          elapsed: elapsed,
      ////          shouldOffsetPhase: true
      ////        )
      ////        return CGPoint(x: x, y: size.height / 2 + y)
      ////      }
      //
      //      let points: [CGPoint] = xPositions.map { x -> CGPoint in
      //        let y = wave.valueAt(
      //          x: x,
      //          in: rect,
      //          elapsed: elapsed,
      //          shouldOffsetPhase: true
      //        )
      //        return CGPoint(x: x, y: rect.midY + y)
      //      }
      //
      //      // Lines
      //      if components.contains(.line) {
      //        var path = Path()
      //        path.addLines(points)
      //        context.stroke(path, with: .color(wave.colour.nativeColour), lineWidth: strokeWidth)
      //      }
      //
      //      // Points
      //      if components.contains(.points) {
      //        let dotPath = Path(ellipseIn: CGRect(x: -2.5, y: -2.5, width: 5, height: 5))
      //        for p in points {
      //          context.translateBy(x: p.x, y: p.y)
      //          context.fill(dotPath, with: .color(.brown))
      //          context.translateBy(x: -p.x, y: -p.y)
      //        }
      //      }
      //
      //      if components.contains(.phaseGhost) {
      //        context.stroke(
      //          linePath,
      //          with: .color(wave.colour.nativeColour.lowOpacity),
      //          style: .dashed(strokeWidth: strokeWidth, gap: strokeWidth / 2)
      //        )
      //      }

      //      // Draw line
      //      var linePath = Path()
      //
      //      if components.contains(.points) {
      //        linePath.addDot(at: point, radius: 5, using: .controlBezier)
      //      } else {
      //        linePath.addLines(points)
      //      }

      //      context.stroke(linePath, with: .color(wave.colour.nativeColour), lineWidth: strokeWidth)

      // MARK: - Dots
      //      let dots = WaveShape(
      //        wave: wave,
      //        elapsed: elapsed,
      //        sampleCount: sampleCount,
      //        shouldOffsetPhase: true,
      //        isDotStyle: true
      //      )
      //            context.fill(linePath, with: .color(.brown))

      // MARK: - Phase offset ghost
      //      if wave.phaseOffset.displayed > 0 {

      //        let phaseGhost = WaveShape(
      //          wave: wave,
      //          elapsed: elapsed,
      //          sampleCount: sampleCount,
      //          shouldOffsetPhase: false,
      //          isDotStyle: false
      //        )
      //        let ghostPath = phaseGhost.path(in: rect)
      //      }

      // MARK: - Base line
      //      context.stroke(horizonPath, with: .color(.gray.lowOpacity))

      //      context.drawHorizonLine(
      //        in: rect.size,
      //        colour: .gray.lowOpacity,
      //      )

      //      let rect = waveRect(in: size)
      //
      //      // MARK: - Wave
      //      let waveLine = WaveShape(
      //        wave: wave,
      //        elapsed: elapsed,
      //        sampleCount: sampleCount,
      //        shouldOffsetPhase: true,
      //        isDotStyle: false
      //      )
      //      context.stroke(
      //        waveLine.path(in: rect),
      //        with: .color(wave.colour.nativeColour),
      //        lineWidth: strokeWidth
      //      )

    }  // END canvas
    .frame(minHeight: minHeight, maxHeight: .infinity)

    .debugTextOverlay(
      """
        Elapsed: \(elapsed.displayString)

        Wave:
        Freq: \(wave.frequency.displayed.displayString)
        Amp: \(wave.amplitude.displayed.displayString)
        Noise: \(wave.noise.displayed.displayString)
        Phase Offset: \(wave.phaseOffset.displayed.displayString)
      """
      //      padding: (.top, Styles.toolbarHeightPrimary)
    )
    //    .background(.black.lowOpacity)

  }
}
extension WaveView {

  private func recomputeStatic(for size: CGSize) {
    guard sampleCount > 1 else {
      xPositions = []
      spatialPhases = []
      return
    }

    // X positions - ensure we don't divide by zero
    let step = size.width / CGFloat(sampleCount - 1)
    xPositions = (0..<sampleCount).map { CGFloat($0) * step }

    // Spatial phases
    let kx = size.width > 0 ? (2 * .pi * wave.cyclesAcross) / size.width : 0
    spatialPhases = xPositions.map { kx * $0 }

    // Horizon path
    horizonPath = Path { p in
      p.move(to: CGPoint(x: 0, y: size.height / 2))
      p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
    }

    // Update tracking variables
    lastComputedSize = size
    lastComputedSampleCount = sampleCount
  }

  private func generateWavePoints(amp: CGFloat, phase: CGFloat, size: CGSize) -> [CGPoint] {
    guard spatialPhases.count == sampleCount && xPositions.count == sampleCount else {
      return []
    }

    var points: [CGPoint] = []
    points.reserveCapacity(sampleCount)

    let centerY = size.height / 2

    for i in 0..<sampleCount {
      // Safe array access - this should never fail now, but keeping for extra safety
      guard i < xPositions.count && i < spatialPhases.count else {
        break
      }

      let x = xPositions[i]
      let spatialPhase = spatialPhases[i]
      let y = centerY + amp * sin(phase + spatialPhase)

      points.append(CGPoint(x: x, y: y))
    }

    return points
  }

  private func drawWaveLine(context: GraphicsContext, points: [CGPoint]) {
    guard points.count > 1 else { return }

    var linePath = Path()
    linePath.addLines(points)
    context.stroke(
      linePath,
      with: .color(wave.colour.nativeColour),
      lineWidth: strokeWidth
    )
  }

  private func drawWavePoints(context: GraphicsContext, points: [CGPoint]) {
    let dotRadius: CGFloat = 2.5
    let dot = Path(
      ellipseIn: CGRect(
        x: -dotRadius,
        y: -dotRadius,
        width: dotRadius * 2,
        height: dotRadius * 2
      ))

    for point in points {
      var pointContext = context
      pointContext.translateBy(x: point.x, y: point.y)
      pointContext.fill(dot, with: .color(.brown))
    }
  }

  private func drawGhostWave(context: GraphicsContext, mainPoints: [CGPoint], size: CGSize) {
    let omega = wave.frequency.displayed * 2 * .pi
    let phaseGhost = omega * elapsed  // ghost has no phase offset

    let ghostPoints = generateGhostPoints(
      from: mainPoints,
      phase: phaseGhost,
      size: size
    )

    guard ghostPoints.count > 1 else { return }

    var ghostPath = Path()
    ghostPath.addLines(ghostPoints)
    context.stroke(
      ghostPath,
      with: .color(wave.colour.nativeColour.lowOpacity),
      style: .init(
        lineWidth: strokeWidth,
        lineCap: .round,
        lineJoin: .round,
        dash: [strokeWidth, strokeWidth / 2]
      )
    )
  }

  private func generateGhostPoints(
    from mainPoints: [CGPoint],
    phase: CGFloat,
    size: CGSize
  ) -> [CGPoint] {
    guard !mainPoints.isEmpty,
      spatialPhases.count == mainPoints.count
    else {
      return []
    }

    var ghostPoints: [CGPoint] = []
    ghostPoints.reserveCapacity(mainPoints.count)

    let centerY = size.height / 2
    let amp = wave.amplitude.displayed

    for i in 0..<mainPoints.count {
      // Safe access with bounds checking
      guard i < spatialPhases.count else { break }

      let mainPoint = mainPoints[i]
      let spatialPhase = spatialPhases[i]
      let ghostY = centerY + amp * sin(phase + spatialPhase)

      ghostPoints.append(CGPoint(x: mainPoint.x, y: ghostY))
    }

    return ghostPoints
  }

  //  private func recomputeStatic(for size: CGSize) {
  //    // X positions
  //    let step = size.width / CGFloat(sampleCount - 1)
  //    xPositions = (0..<sampleCount).map { CGFloat($0) * step }
  //
  //    // Spatial phases
  //    let kx = (2 * .pi * wave.cyclesAcross) / size.width
  //    spatialPhases = xPositions.map { kx * $0 }
  //
  //    // Horizon path
  //    horizonPath = Path { p in
  //      p.move(to: CGPoint(x: 0, y: size.height / 2))
  //      p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
  //    }
  //  }
  //
  //  private func ghostPoints(
  //    from points: [CGPoint],
  //    using spatialPhases: [CGFloat],
  //    phaseShift: CGFloat,
  //    wave: Wave
  //  ) -> [CGPoint] {
  //    guard !points.isEmpty, !spatialPhases.isEmpty else { return [] }
  //
  //    var ghost = [CGPoint]()
  //    let count = min(points.count, spatialPhases.count)
  //
  //    for i in 0..<count {
  //      let p = points[i]
  //      let sp = spatialPhases.indices.contains(i) ? spatialPhases[i] : 0
  //      let ghostY = sin(sp + phaseShift) * wave.amplitude.displayed
  //      ghost.append(CGPoint(x: p.x, y: ghostY))
  //    }
  //
  //    return ghost
  //  }

  //  private func recomputeStatic(for size: CGSize) {
  //    xPositions = (0..<sampleCount).map {
  //      size.width * CGFloat($0) / CGFloat(sampleCount - 1)
  //    }
  //    horizonPath = Path { p in
  //      p.move(to: CGPoint(x: 0, y: size.height / 2))
  //      p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
  //    }
  //  }

  //  private func waveRect(in size: CGSize) -> CGRect {
  //    let rectHeight = size.height.clamped(minHeight ?? 10, CGFloat.infinity)
  //    let rectSize = CGSize(width: size.width, height: rectHeight)
  //    let rect = CGRect(origin: .zero, size: rectSize)
  //    return rect
  //  }

  private var minHeight: CGFloat? {
    switch waveViewStyle {
      case .standard:
        return nil
      case .preview(let maxHeight):
        return maxHeight
    }
  }
}

public enum WaveViewStyle: Equatable {
  case standard
  case preview(maxHeight: CGFloat = 50)
}
