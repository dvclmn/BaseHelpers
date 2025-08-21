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

      /// Ensure valid data before proceeding
      guard dataIsValid(size: size) else { return }

      /// Recompute static geometry only if needed
      if needsRecomputation(size: size) {
        Task { @MainActor in
          recomputeStatic(for: size)
        }
      }

      /// Safety check: ensure arrays are properly initialized
      guard
        xPositions.count == sampleCount
          && spatialPhases.count == sampleCount
      else { return }

      /// Precompute frame-specific dynamic parts
      let omega = wave.frequency.displayed * 2 * .pi
      let amp = wave.amplitude.displayed
      let phaseMain = omega * elapsed + wave.phaseOffset.displayed

      /// Generate main wave points
      let mainPoints = generateWavePoints(
        amp: amp,
        phase: phaseMain,
        size: size
      )

      /// Main wave line
      if components.contains(.line) {
        drawWaveLine(context: context, points: mainPoints)
      }

      /// Points
      if components.contains(.points) {
        drawWavePoints(context: context, points: mainPoints)
      }

      /// Ghost line
      if wave.phaseOffset.displayed > 0, components.contains(.phaseGhost) {
        drawGhostWave(context: context, mainPoints: mainPoints, size: size)
      }

      /// Horizon
      context.stroke(horizonPath, with: .color(.gray.lowOpacity))

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

  private func dataIsValid(size: CGSize) -> Bool {
    return size.width > 0
      && size.height > 0
      && sampleCount > 0
  }

  private func needsRecomputation(size: CGSize) -> Bool {
    return xPositions.count != sampleCount
      || spatialPhases.count != sampleCount
      || lastComputedSize != size
      || lastComputedSampleCount != sampleCount
  }

  private func recomputeStatic(for size: CGSize) {
    guard sampleCount > 1 else {
      xPositions = []
      spatialPhases = []
      return
    }

    /// X positions - ensure we don't divide by zero
    let step = size.width / CGFloat(sampleCount - 1)
    xPositions = (0..<sampleCount).map { CGFloat($0) * step }

    /// Spatial phases
    let kx = size.width > 0 ? (2 * .pi * wave.cyclesAcross) / size.width : 0
    spatialPhases = xPositions.map { kx * $0 }

    /// Horizon path
    horizonPath = Path { p in
      p.move(to: CGPoint(x: 0, y: size.height / 2))
      p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
    }

    /// Update tracking variables
    lastComputedSize = size
    lastComputedSampleCount = sampleCount
  }

  private func generateWavePoints(
    amp: CGFloat,
    phase: CGFloat,
    size: CGSize
  ) -> [CGPoint] {
    guard spatialPhases.count == sampleCount && xPositions.count == sampleCount else {
      return []
    }

    var points: [CGPoint] = []
    points.reserveCapacity(sampleCount)

    let centerY = size.height / 2

    for i in 0..<sampleCount {
      /// Safe array access - this should never fail, but keeping for extra safety
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

  private var minHeight: CGFloat? {
    switch waveViewStyle {
      case .standard:
        return nil
      case .preview(let maxHeight):
        return maxHeight
    }
  }
}
