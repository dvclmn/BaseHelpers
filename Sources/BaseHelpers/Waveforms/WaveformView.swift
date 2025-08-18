//
//  Waveforms.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

/// Phase-continuous waveform drawn by Canvas
///
/// Note: it's expected that this View will be embedded in a `TimelineView`
public struct WaveformView: View {

  @Binding var engine: WaveEngine
  let strokeWidth: CGFloat
  let sampleCount: Int

  public init(
    engine: Binding<WaveEngine>,
    strokeWidth: CGFloat = 2,
    sampleCount: Int = 200,
  ) {
    self._engine = engine
    self.strokeWidth = strokeWidth
    self.sampleCount = sampleCount
  }

  public var body: some View {

    Canvas {
      context,
      size in
      let rect = CGRect(origin: .zero, size: size)

      /// Wave
      let wave = WaveShape(
        engine: engine,
        sampleCount: sampleCount
      )
      let path = wave.path(in: rect)

      /// Stroke
      context.stroke(path, with: .color(.accentColor), lineWidth: strokeWidth)

      /// Baseline
      let midY = rect.midY
      let baselinePath = Path { p in
        p.move(to: CGPoint(x: rect.minX, y: midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: midY))
      }
      context.stroke(baselinePath, with: .color(.gray.lowOpacity), lineWidth: 1)
      context.stroke(
        baselinePath,
        with: .color(.gray.lowOpacity),
        style: .dashed(strokeWidth: 1)
      )
    }
    .background(.black.lowOpacity)

  }

}

extension WaveformView {
  //  @ViewBuilder
  //  func Legend() -> some View {
  //    VStack(alignment: .leading, spacing: 6) {
  //      Label(String(format: "f: %.2f Hz", engine.displayedFrequency), systemImage: "metronome")
  //      Label(String(format: "A: %.0f px", engine.displayedAmplitude), systemImage: "arrow.up.and.down")
  //      Label(String(format: "cycles: %.2f / width", engine.displayedCyclesAcross), systemImage: "waveform")
  //    }
  //    .font(.caption2.monospaced())
  //    .padding(6)
  //    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
  //
  //  }

}
