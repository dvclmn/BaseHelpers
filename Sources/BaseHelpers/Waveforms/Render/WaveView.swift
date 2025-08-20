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
  @State private var horizonPath: Path = .init()

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
    waveViewStyle: WaveViewStyle = .standard
  ) {
    self.wave = wave
    self.elapsed = elapsed
    self.strokeWidth = strokeWidth
    self.sampleCount = sampleCount
    self.waveViewStyle = waveViewStyle
  }

  public var body: some View {

    Canvas {
      context,
      size in

      /// On size/sampleCount change → recompute static values
      if xPositions.count != sampleCount {
        Task { @MainActor in
          recomputeStatic(for: size)
        }
      }

      /// Per tick: compute Y values
      let points = xPositions.map { x -> CGPoint in
        let y = wave.valueAt(
          x: x,
          in: CGRect(origin: .zero, size: size),
          elapsed: elapsed,
          shouldOffsetPhase: true
        )
        return CGPoint(x: x, y: size.height / 2 + y)
      }

      // Draw line
      var linePath = Path()
      
      
      p.addDot(at: point, radius: 5, using: .controlBezier)
      linePath.addLines(points)

      context.stroke(linePath, with: .color(wave.colour.nativeColour), lineWidth: strokeWidth)

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
      if wave.phaseOffset.displayed > 0 {

        //        let phaseGhost = WaveShape(
        //          wave: wave,
        //          elapsed: elapsed,
        //          sampleCount: sampleCount,
        //          shouldOffsetPhase: false,
        //          isDotStyle: false
        //        )
        //        let ghostPath = phaseGhost.path(in: rect)
        context.stroke(
          linePath,
          with: .color(wave.colour.nativeColour.lowOpacity),
          style: .dashed(strokeWidth: strokeWidth, gap: strokeWidth / 2)
        )
      }

      // MARK: - Base line
      context.stroke(horizonPath, with: .color(.gray.lowOpacity))

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
    xPositions = (0..<sampleCount).map {
      size.width * CGFloat($0) / CGFloat(sampleCount - 1)
    }
    horizonPath = Path { p in
      p.move(to: CGPoint(x: 0, y: size.height / 2))
      p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
    }
  }

  private func waveRect(in size: CGSize) -> CGRect {
    let rectHeight = size.height.clamped(minHeight ?? 10, CGFloat.infinity)
    let rectSize = CGSize(width: size.width, height: rectHeight)
    let rect = CGRect(origin: .zero, size: rectSize)
    return rect
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

public enum WaveViewStyle: Equatable {
  case standard
  case preview(maxHeight: CGFloat = 50)
}
