//
//  Model+Wave.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import GameplayKit
import SwiftUI

public protocol WaveBase: Sendable, Codable, Equatable, Hashable {
//  associatedtype Colour: CodableColour
}

/// The advantages of this “elapsed-only” engine:
/// - Waves are fully self-contained: frequency, amplitude,
///   and phase offset are all local.
/// - No need for global phase wrapping: just pass elapsed time forward.
/// - Flexibility: if you later add modulation (e.g. frequency envelopes),
///   it’s easy because each wave already computes its own phase internally.
///
/// `cyclesAcross` is a bit like a Wave 'zoom level'. How much
/// of the Wave we see in a View's width. Does not effect
/// the outputted wave `value` at all.
//
/// The user has the choice to either specify a per-Wave
/// cycles value here, or there is also a global setting
/// if they are happy to keep it the same for all Waves.
public struct Wave<T: CodableColour>: WaveBase, Identifiable {
//  public typealias Colour = T
  
  public let id: UUID
  public var frequency: SmoothedProperty
  public var amplitude: SmoothedProperty
  public var phaseOffset: SmoothedProperty
  public var noise: SmoothedProperty
  public var cyclesAcross: CGFloat
  public var colour: T

  public init(
    id: UUID = UUID(),
    frequency: CGFloat,
    amplitude: CGFloat,
    phaseOffset: CGFloat = 0,
    cyclesAcross: CGFloat = 2,
    colour: T
  ) {
    self.id = id
    self.frequency = SmoothedProperty(frequency)
    self.amplitude = SmoothedProperty(amplitude)
    self.phaseOffset = SmoothedProperty(phaseOffset)
    self.noise = SmoothedProperty(.zero)
    self.cyclesAcross = cyclesAcross
    self.colour = colour

  }
}

extension Wave {

  private var omega: CGFloat { frequency.displayed * 2 * .pi }
  private func phase(elapsed: CGFloat) -> CGFloat {
    omega * elapsed + phaseOffset.displayed
  }

  /// Smooth parameters towards target each tick
  public mutating func updateProperties(dt: CGFloat, smoothing: CGFloat) {
    frequency.update(dt: dt, smoothing: smoothing)
    amplitude.update(dt: dt, smoothing: smoothing)
    phaseOffset.update(dt: dt, smoothing: smoothing)
  }

  /// Evaluate wave value at given elapsed time (seconds since start)
  public func value(elapsed: CGFloat) -> CGFloat {
    let phase = self.phase(elapsed: elapsed)
    let sinPhase = sin(phase)
    return amplitude.displayed * sinPhase
  }

  /// For WaveShape
  //  func valueAt(
  //    x: CGFloat,
  //    in rect: CGRect,
  //    elapsed: CGFloat,
  //    shouldOffsetPhase: Bool = true,
  //  ) -> CGFloat {
  //    let omega = frequency.displayed * 2 * .pi
  //    let offset: CGFloat = shouldOffsetPhase ? phaseOffset.displayed : 0
  //    let temporalPhase = omega * elapsed + offset
  //    let kx = (2 * .pi * cyclesAcross) / rect.width
  //    let spatialPhase = kx * (x - rect.minX)
  //    let raw = sin(temporalPhase + spatialPhase)
  //    return amplitude.displayed * raw
  //  }

  private static var validRange: ClosedRange<CGFloat> { -1...1 }

}
