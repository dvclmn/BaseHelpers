//
//  Waveforms.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import Combine
import QuartzCore
import SwiftUI

// MARK: - WaveEngine
/// Drives a phase-continuous waveform with parameter smoothing.
/// - Integrates phase using `displayedFrequency` so phase never resets.
/// - Smooths parameter changes (frequency, amplitude, vertical offset) with a time constant.
@MainActor
final class WaveEngine: ObservableObject {
  // Public, user-controlled targets (bind these to sliders)
  @Published var targetFrequency: CGFloat = 1.2  // Hz (temporal)
  @Published var targetAmplitude: CGFloat = 40  // px
  @Published var targetBaseline: CGFloat = 0  // px vertical offset
  @Published var targetCyclesAcross: CGFloat = 1.5  // cycles across view width (spatial)

  // Smoothed/displayed values (what the renderer uses)
  @Published private(set) var displayedFrequency: CGFloat = 1.2
  @Published private(set) var displayedAmplitude: CGFloat = 40
  @Published private(set) var displayedBaseline: CGFloat = 0
  @Published private(set) var displayedCyclesAcross: CGFloat = 1.5

  // Phase accumulator (radians)
  private(set) var phase: CGFloat = 0

  // Tuning: smaller = snappier, larger = smoother. (seconds)
  var smoothingTimeConstant: CGFloat = 0.12

  // Internal timekeeping
  private var lastTime: CFTimeInterval?

  func tick(now: CFTimeInterval) {
    // Compute dt
    let dt: CGFloat
    if let last = lastTime { dt = max(0, CGFloat(now - last)) } else { dt = 0 }
    lastTime = now

    // 1) Exponential smoothing for parameters
    //    displayed += (target - displayed) * (1 - e^{-dt/τ})
    if dt > 0 {
      let alpha = 1 - exp(-dt / max(0.0001, smoothingTimeConstant))
      displayedFrequency += (targetFrequency - displayedFrequency) * alpha
      displayedAmplitude += (targetAmplitude - displayedAmplitude) * alpha
      displayedBaseline += (targetBaseline - displayedBaseline) * alpha
      displayedCyclesAcross += (targetCyclesAcross - displayedCyclesAcross) * alpha
    } else {
      // First frame: snap
      displayedFrequency = targetFrequency
      displayedAmplitude = targetAmplitude
      displayedBaseline = targetBaseline
      displayedCyclesAcross = targetCyclesAcross
    }

    //    // 2) Integrate phase for continuity (φ += 2π f dt)
    //    phase &+= (2 * .pi) * displayedFrequency * dt
    //    // keep φ in a safe range to avoid float blow-up
    //    if phase > 1_000_000 { phase.formTruncatingRemainder(dividingBy: 2 * .pi) }

    phase += (2 * .pi) * displayedFrequency * dt
    // Wrap into a reasonable range (e.g. 0…2π) to avoid float blow-up
    if phase > .pi * 4 || phase < -.pi * 4 {
      phase.formTruncatingRemainder(dividingBy: 2 * .pi)
    }
  }
}

// MARK: - WaveShape
struct WaveShape: Shape {
  var phase: CGFloat  // temporal phase (radians)
  var amplitude: CGFloat  // px
  var baseline: CGFloat  // px
  var cyclesAcross: CGFloat  // cycles across rect.width
  var sampleCount: Int = 600

  func path(in rect: CGRect) -> Path {
    var p = Path()
    guard rect.width > 1, sampleCount > 1 else { return p }

    let midY = rect.midY + baseline
    let kx = (2 * .pi * cyclesAcross) / rect.width
    let step = rect.width / CGFloat(sampleCount - 1)

    var x: CGFloat = rect.minX
    var first = true
    for _ in 0..<sampleCount {
      let y = midY + amplitude * sin(phase + kx * (x - rect.minX))
      if first {
        p.move(to: CGPoint(x: x, y: y))
        first = false
      } else {
        p.addLine(to: CGPoint(x: x, y: y))
      }
      x += step
    }
    return p
  }
}

// MARK: - WaveView (Canvas-based, phase-continuous)
struct WaveView: View {
  @ObservedObject var engine: WaveEngine
  var strokeWidth: CGFloat = 2
  var sampleCount: Int = 800

  var body: some View {
    TimelineView(.animation) { context in

      Canvas { g, size in
        let rect = CGRect(origin: .zero, size: size)

        // Grid (nice for intuition)
        drawMinorGrid(in: rect, into: &g)

        // Wave
        let wave = WaveShape(
          phase: engine.phase,
          amplitude: engine.displayedAmplitude,
          baseline: engine.displayedBaseline,
          cyclesAcross: engine.displayedCyclesAcross,
          sampleCount: sampleCount
        )
        let path = wave.path(in: rect)

        // Stroke
        g.stroke(path, with: .color(.accentColor), lineWidth: strokeWidth)

        // Baseline
        let midY = rect.midY + engine.displayedBaseline
        let baselinePath = Path { p in
          p.move(to: CGPoint(x: rect.minX, y: midY))
          p.addLine(to: CGPoint(x: rect.maxX, y: midY))
        }
        g.stroke(baselinePath, with: .color(.secondary), lineWidth: 1)
      }
      .background(.ultraThinMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

      .task(id: context.date.timeIntervalSinceReferenceDate) {
        // Drive the engine from TimelineView's clock
        engine.tick(now: context.date.timeIntervalSinceReferenceDate)
      }
    }
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

// MARK: - Playground Shell
public struct WavePlaygroundView: View {
  @StateObject private var engine = WaveEngine()
  @State private var emoji: String = "🫧"

  public init() {}

  public var body: some View {
    VStack(spacing: 16) {
      // Emoji viewport
      ZStack {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(.thinMaterial)
        Text(emoji)
          .font(.system(size: 100))
          .shadow(radius: 3)
      }
      .frame(height: 180)

      // Waves
      WaveView(engine: engine, strokeWidth: 2, sampleCount: 900)
        .frame(height: 180)
        .overlay(alignment: .topLeading) {
          legend
            .padding(8)
        }

      // Inspector
      inspector
    }
    .padding(20)
    .animation(.default, value: engine.targetCyclesAcross)  // cosmetic
  }

  private var legend: some View {
    VStack(alignment: .leading, spacing: 6) {
      Label(String(format: "f: %.2f Hz", engine.displayedFrequency), systemImage: "metronome")
      Label(String(format: "A: %.0f px", engine.displayedAmplitude), systemImage: "arrow.up.and.down")
      Label(String(format: "cycles: %.2f / width", engine.displayedCyclesAcross), systemImage: "waveform")
    }
    .font(.caption2.monospaced())
    .padding(6)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
  }

  private var inspector: some View {
    VStack(spacing: 12) {
      HStack {
        Text("Frequency")
        Slider(value: $engine.targetFrequency, in: 0.05...6.0)
        Text(String(format: "%.2f Hz", engine.targetFrequency))
          .font(.caption.monospaced())
          .frame(width: 80, alignment: .trailing)
      }
      HStack {
        Text("Amplitude")
        Slider(value: $engine.targetAmplitude, in: 0...120)
        Text(String(format: "%.0f px", engine.targetAmplitude))
          .font(.caption.monospaced())
          .frame(width: 80, alignment: .trailing)
      }
      HStack {
        Text("Baseline")
        Slider(value: $engine.targetBaseline, in: -80...80)
        Text(String(format: "%+.0f px", engine.targetBaseline))
          .font(.caption.monospaced())
          .frame(width: 80, alignment: .trailing)
      }
      HStack {
        Text("Cycles Across")
        Slider(value: $engine.targetCyclesAcross, in: 0.2...8.0)
        Text(String(format: "%.2f", engine.targetCyclesAcross))
          .font(.caption.monospaced())
          .frame(width: 80, alignment: .trailing)
      }
      HStack {
        Text("Smoothing τ")
        Slider(
          value: Binding(
            get: { engine.smoothingTimeConstant },
            set: { engine.smoothingTimeConstant = max(0.016, $0) }
          ), in: 0.02...0.40)
        Text(String(format: "%.0f ms", engine.smoothingTimeConstant * 1000))
          .font(.caption.monospaced())
          .frame(width: 80, alignment: .trailing)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(14)
    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

// MARK: - Preview
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview {
  Group {
    WavePlaygroundView()
      .preferredColorScheme(.light)
    WavePlaygroundView()
      .preferredColorScheme(.dark)
  }
  //  .previewLayout(.sizeThatFits)
  .frame(width: 760)
}
#endif
