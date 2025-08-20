//
//  Model+Wave.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

/// The advantages of this “elapsed-only” engine:
/// - Waves are fully self-contained: frequency, amplitude,
///   and phase offset are all local.
/// - No need for global phase wrapping: just pass elapsed time forward.
/// - Flexibility: if you later add modulation (e.g. frequency envelopes),
///   it’s easy because each wave already computes its own phase internally.
public struct Wave: Documentable, Identifiable {
  public let id: UUID
  public var frequency: SmoothedProperty
  public var amplitude: SmoothedProperty
  public var phaseOffset: SmoothedProperty
  public var noise: SmoothedProperty

  /// Aka a bit like a Wave 'zoom level'. How much of the
  /// Wave we see in a View's width. Does not effect
  /// the outputted wave `value` at all.
  ///
  /// The user has the choice to either specify a per-Wave
  /// cycles value here, or there is also a global setting
  /// if they are happy to keep it the same for all Waves.
  public var cyclesAcross: CGFloat
  public var colour: Swatch

  public init(
    id: UUID = UUID(),
    frequency: CGFloat,
    amplitude: CGFloat,
    phaseOffset: CGFloat = 0,
    noise: CGFloat = 0,
    //    frequency: SmoothedProperty = .init(6),
    //    amplitude: SmoothedProperty = .init(30),
    //    phaseOffset: SmoothedProperty = .init(.zero),
    //    noise: SmoothedProperty = .init(.zero),
    cyclesAcross: CGFloat = 2,
    colour: Swatch = .blue20
  ) {
    self.id = id
    self.frequency = SmoothedProperty(frequency)
    self.amplitude = SmoothedProperty(amplitude)
    self.phaseOffset = SmoothedProperty(phaseOffset)
    self.noise = SmoothedProperty(noise)
    self.cyclesAcross = cyclesAcross
    self.colour = colour
  }
}

extension Wave {

  /// Smooth parameters towards target each tick
  public mutating func update(dt: CGFloat, smoothing: CGFloat) {
    frequency.update(dt: dt, smoothing: smoothing)
    amplitude.update(dt: dt, smoothing: smoothing)
    phaseOffset.update(dt: dt, smoothing: smoothing)
    noise.update(dt: dt, smoothing: smoothing)
  }

  /// Evaluate wave value at given elapsed time (seconds since start)
  public func value(elapsed: CGFloat) -> CGFloat {
    let omega = frequency.displayed * 2 * .pi
    let phase = omega * elapsed + phaseOffset.displayed
    let raw = sin(phase)
    let noisy = raw + noiseContribution()
    return amplitude.displayed * noisy
  }

  //  public func value(elapsed: CGFloat) -> CGFloat {
  //    /// frequency is `Hz`, so multiply by `2πf * t`
  //    let base = calculatePhase(elapsed)
  //    let noisy = addNoise(to: base)
  //    let result = amplitude.displayed * noisy
  //    precondition(result.isWithin(Self.validRange), "Wave output is not between -1 and 1.")
  //    return result
  //  }
  //
//  public func calculatePhase(_ elapsed: CGFloat) -> CGFloat {
//    let omega = frequency.displayed * 2 * .pi
//    let phase = omega * elapsed + phaseOffset.displayed
//    //    let phase = 2 * .pi * frequency.displayed * elapsed + phaseOffset.displayed
//    return amplitude.displayed * sin(phase)
//  }

  private func noiseContribution() -> CGFloat {
    guard noise.displayed != 0 else { return 0 }
    return (CGFloat.random(in: -1...1) * noise.displayed)
  }

//  public func somethingCyclesInWidth(
//    elapsed: CGFloat,
//    x: CGFloat,
//    in rect: CGRect
//  ) -> CGFloat {
//    let phase = calculatePhase(elapsed)
//    let midY = rect.midY
//    //    let x: CGFloat = rect.minX
//    let kx = (2 * .pi * cyclesAcross) / rect.width
//    return midY + amplitude.displayed * sin(phase + kx * (x - rect.minX))
//  }

  //  private func addNoise(to base: CGFloat) -> CGFloat {
  //    return base + (noise.displayed * CGFloat.randomNoise())
  //  }

  private static let validRange: ClosedRange<CGFloat> = -1...1

  /// Important: phase is now handled externally via a single `WaveEngine`.
  /// A `Wave` only holds onto a phase offset, which is *added* to the base phase.
  ///
  /// This `value` just produces a float between `-1` and `1`
  //  public func value(at elapsed: TimeInterval) -> CGFloat {
  //    let θ = 2 * .pi * frequency.displayed * elapsed + phaseOffset.displayed
  //    let base = sin(θ)
  //    let noisy = base + (noise.displayed * CGFloat.randomNoise())
  //    return amplitude.displayed * noisy
  //  }
  //  public func value(
  //    globalPhase: CGFloat
  ////    at phase: CGFloat
  //      //    at time: TimeInterval
  //  ) -> CGFloat {
  //    // per-wave frequency still scales the *global phase*
  //    let θ = globalPhase * frequency.displayed + phaseOffset.displayed
  //    let base = sin(θ)
  //    let noisy = base + (noise.displayed * CGFloat.randomNoise())
  //    return amplitude.displayed * noisy
  //
  ////    let base = sin(phase + phaseOffset.displayed)
  ////    let noisy = base + (noise.displayed * CGFloat.randomNoise())
  ////    let result = amplitude.displayed * noisy
  ////    precondition(result.isWithin(Self.validRange), "Wave output is not between -1 and 1.")
  ////    return result
  //  }

}
