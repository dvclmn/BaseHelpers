//
//  Waveforms.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

public enum WaveViewStyle: Equatable {
  case standard
  case preview(maxHeight: CGFloat = 50)
}

/// Phase-continuous waveform drawn by Canvas
///
/// Note: it's expected that this View will be embedded in a `TimelineView`
public struct WaveView: View {
  let wave: Wave
  let elapsed: CGFloat
  let strokeWidth: CGFloat
  let sampleCount: Int
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

      let rect = waveRect(in: size)

      /// Wave
      let waveLine = WaveShape(
        wave: wave,
        elapsed: elapsed,
        sampleCount: sampleCount,
        shouldOffsetPhase: true,
        isDotStyle: false
      )
      let dots = WaveShape(
        wave: wave,
        elapsed: elapsed,
        sampleCount: sampleCount,
        shouldOffsetPhase: true,
        isDotStyle: true
      )

      context.stroke(
        waveLine.path(in: rect),
        with: .color(wave.colour.nativeColour),
        lineWidth: strokeWidth
      )

      context.fill(dots.path(in: rect), with: .color(.brown))
      //        dots.path(in: rect),
      //        with: .color(wave.colour.nativeColour),
      //        lineWidth: strokeWidth
      //      )

      /// Phase offset ghost
      if wave.phaseOffset.displayed > 0 {
        let phaseGhost = WaveShape(
          wave: wave,
          elapsed: elapsed,
          sampleCount: sampleCount,
          shouldOffsetPhase: false,
          isDotStyle: false
        )
        let ghostPath = phaseGhost.path(in: rect)
        context.stroke(
          ghostPath,
          with: .color(wave.colour.nativeColour.lowOpacity),
          style: .dashed(strokeWidth: strokeWidth, gap: strokeWidth / 2)
        )
      }

      /// Baseline
      context.drawHorizonLine(
        in: rect.size,
        colour: .gray.lowOpacity,
      )
    }  // END canvas
    .frame(minHeight: minHeight, maxHeight: .infinity)

    //    .debugTextOverlay(
    //      """
    //      Elapsed: \(elapsed.displayString)
    //
    //      Wave:
    //      Freq: \(wave.frequency.displayed.displayString)
    //      Amp: \(wave.amplitude.displayed.displayString)
    //      Noise: \(wave.noise.displayed.displayString)
    //      Phase Offset: \(wave.phaseOffset.displayed.displayString)
    //      """,
    //      padding: (.top, Styles.toolbarHeightPrimary)
    //    )
    //    .background(.black.lowOpacity)

  }
}
extension WaveView {

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
