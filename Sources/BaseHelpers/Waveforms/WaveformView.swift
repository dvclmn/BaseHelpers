//
//  Waveforms.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import Combine
import QuartzCore
import SwiftUI

/// Phase-continuous waveform drawn by Canvas
///
/// Note: it's expected that this View will be embedded in a `TimelineView`
public struct WaveView: View {
  @Environment(WaveEngine.self) private var engine

  let strokeWidth: CGFloat
  let sampleCount: Int

  public init(
    strokeWidth: CGFloat = 2,
    sampleCount: Int = 200,
  ) {
    self.strokeWidth = strokeWidth
    self.sampleCount = sampleCount
  }

  public var body: some View {

    Canvas { g, size in
      let rect = CGRect(origin: .zero, size: size)

      drawMinorGrid(in: rect, into: &g)

      /// Wave
      let wave = WaveShape(
        phase: engine.phase,
        amplitude: engine.displayedAmplitude,
//        baseline: engine.displayedBaseline,
        cyclesAcross: engine.displayedCyclesAcross,
        sampleCount: sampleCount
      )
      let path = wave.path(in: rect)

      /// Stroke
      g.stroke(path, with: .color(.accentColor), lineWidth: strokeWidth)

      // Baseline
      //      let midY = rect.midY + engine.displayedBaseline
      //      let baselinePath = Path { p in
      //        p.move(to: CGPoint(x: rect.minX, y: midY))
      //        p.addLine(to: CGPoint(x: rect.maxX, y: midY))
      //      }
      //      g.stroke(baselinePath, with: .color(.secondary), lineWidth: 1)
    }
    
    Legend()

  }

}

extension WaveView {
  @ViewBuilder
  func Legend() -> some View {
    VStack(alignment: .leading, spacing: 6) {
      Label(String(format: "f: %.2f Hz", engine.displayedFrequency), systemImage: "metronome")
      Label(String(format: "A: %.0f px", engine.displayedAmplitude), systemImage: "arrow.up.and.down")
      Label(String(format: "cycles: %.2f / width", engine.displayedCyclesAcross), systemImage: "waveform")
    }
    .font(.caption2.monospaced())
    .padding(6)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

  }

  private func drawMinorGrid(in rect: CGRect, into g: inout GraphicsContext) {
    let cols = 8
    let rows = 4
    let dx = rect.width / CGFloat(cols)
    let dy = rect.height / CGFloat(rows)
    var path = Path()
    for i in 1..<cols {
      let x = rect.minX + CGFloat(i) * dx
      path.move(to: CGPoint(x: x, y: rect.minY))
      path.addLine(to: CGPoint(x: x, y: rect.maxY))
    }
    for j in 1..<rows {
      let y = rect.minY + CGFloat(j) * dy
      path.move(to: CGPoint(x: rect.minX, y: y))
      path.addLine(to: CGPoint(x: rect.maxX, y: y))
    }
    g.stroke(path, with: .color(Color.secondary), lineWidth: 1)
  }
}

//// MARK: - Playground Shell
//public struct WavePlaygroundView: View {
//  @StateObject private var engine = WaveEngine()
//  @State private var emoji: String = "🫧"
//
//  public init() {}
//
//  public var body: some View {
//    VStack(spacing: 16) {
//      // Emoji viewport
//      ZStack {
//        RoundedRectangle(cornerRadius: 16, style: .continuous)
//          .fill(.thinMaterial)
//        Text(emoji)
//          .font(.system(size: 100))
//          .shadow(radius: 3)
//      }
//      .frame(height: 180)
//
//      // Waves
//      WaveView(engine: engine, strokeWidth: 2, sampleCount: 900)
//        .frame(height: 180)
//        .overlay(alignment: .topLeading) {
//          legend
//            .padding(8)
//        }
//
//      // Inspector
//      inspector
//    }
//    .padding(20)
//    .animation(.default, value: engine.targetCyclesAcross)  // cosmetic
//  }
//

//
//  private var inspector: some View {
//
//    .frame(maxWidth: .infinity)
//    .padding(14)
//    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
//  }
//}
//
//// MARK: - Preview
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview {
//  Group {
//    WavePlaygroundView()
//      .preferredColorScheme(.light)
//    WavePlaygroundView()
//      .preferredColorScheme(.dark)
//  }
//  //  .previewLayout(.sizeThatFits)
//  .frame(width: 760)
//}
//#endif
