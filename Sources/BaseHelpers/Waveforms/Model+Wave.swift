//
//  Model+Wave.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import GameplayKit
import SwiftUI

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
public struct Wave: Documentable, Identifiable {
  public let id: UUID
  public var frequency: SmoothedProperty
  public var amplitude: SmoothedProperty
  public var phaseOffset: SmoothedProperty
  public var noise: SmoothedProperty
  public var cyclesAcross: CGFloat
  public var colour: Swatch
  
  

//  private let noiseSeed: UInt64

  public init(
    id: UUID = UUID(),
    frequency: CGFloat,
    amplitude: CGFloat,
    phaseOffset: CGFloat = 0,
//    noise: CGFloat = 0,
    cyclesAcross: CGFloat = 2,
    colour: Swatch = .blue20
  ) {
    self.id = id
    self.frequency = SmoothedProperty(frequency)
    self.amplitude = SmoothedProperty(amplitude)
    self.phaseOffset = SmoothedProperty(phaseOffset)
    self.noise = SmoothedProperty(.zero)
//    self.noise = SmoothedProperty(noise)
    self.cyclesAcross = cyclesAcross
    self.colour = colour

//    let hashValue = id.hashValue
//    print("Hash value: \(hashValue)")
//    print("Abs Hash value: \(abs(hashValue))")

//    self.noiseSeed = UInt64(abs(hashValue))  // Use UUID hash as seed
  }
}

extension Wave {

  //  public mutating func updateTarget(
  //    _ property: WaveProperty,
  //    newValue: CGFloat
  ////    dt: CGFloat,
  ////    smoothing: CGFloat
  //  ) {
  //    self[keyPath: property.keyPath].setTarget(newValue)
  //  }

  //  public mutating func update(
  //    _ property: WaveProperty,
  //    dt: CGFloat,
  //    smoothing: CGFloat
  //  ) {
  //    self[keyPath: property.keyPath].update(dt: dt, smoothing: smoothing)
  //  }

  /// Smooth parameters towards target each tick
  public mutating func updatePropertiesTiming(dt: CGFloat, smoothing: CGFloat) {
    //    update(\.frequency, dt: dt, smoothing: smoothing)
    frequency.update(dt: dt, smoothing: smoothing)
    amplitude.update(dt: dt, smoothing: smoothing)
    phaseOffset.update(dt: dt, smoothing: smoothing)
//    noise.update(dt: dt, smoothing: smoothing)
  }

  /// Evaluate wave value at given elapsed time (seconds since start)
  public func value(elapsed: CGFloat) -> CGFloat {
    let omega = frequency.displayed * 2 * .pi
    let phase = omega * elapsed + phaseOffset.displayed
    let raw = sin(phase)
//    let noisy = raw + noiseContribution(elapsed: elapsed)
    return amplitude.displayed * raw
//    return amplitude.displayed * noisy
  }

  /// For WaveShape
  func valueAt(
    x: CGFloat,
    in rect: CGRect,
    elapsed: CGFloat,
    shouldOffsetPhase: Bool = true,
  ) -> CGFloat {
    let omega = frequency.displayed * 2 * .pi
    let offset: CGFloat = shouldOffsetPhase ? phaseOffset.displayed : 0
    let temporalPhase = omega * elapsed + offset
    let kx = (2 * .pi * cyclesAcross) / rect.width
    let spatialPhase = kx * (x - rect.minX)
    let raw = sin(temporalPhase + spatialPhase)
//    let noisy = raw + noiseContribution(elapsed: elapsed)
    return amplitude.displayed * raw
//    return amplitude.displayed * noisy
  }

//  private func noiseContribution(elapsed: CGFloat) -> CGFloat {
//    guard noise.displayed != 0 else { return 0 }
//
//    // Use multiple sine waves at different frequencies
//    let noiseFreq1 = 13.7
//    let noiseFreq2 = 37.3
//    let noiseFreq3 = 71.1
//
//    let noise1 = sin(elapsed * noiseFreq1)
//    let noise2 = sin(elapsed * noiseFreq2) * 0.5
//    let noise3 = sin(elapsed * noiseFreq3) * 0.25
//
//    // Sum them up
//    let combinedNoise = noise1 + noise2 + noise3
//    // Max possible value: 1 + 0.5 + 0.25 = 1.75
//    // Min possible value: -1 - 0.5 - 0.25 = -1.75
//
//    // Normalize to [-1, 1] range
//    let normalizedNoise = combinedNoise / 1.75
//
//    return normalizedNoise * noise.displayed
//  }

  //  private func noiseContribution(elapsed: CGFloat) -> CGFloat {
  //    guard noise.displayed != 0 else { return 0 }
  //
  //    // Use a combination of sine waves at different frequencies for pseudo-random noise
  //    let noiseFreq1 = 13.7 // Prime numbers work well for pseudo-randomness
  //    let noiseFreq2 = 37.3
  //    let noiseFreq3 = 71.1
  //
  //    let noise1 = elapsed * noiseFreq1
  //    let noise2 = elapsed * noiseFreq2 * 0.5
  //    let noise3 = elapsed * noiseFreq3 * 0.25
  //
  //    let combinedNoise = (noise1 + noise2 + noise3) / 1.75 // Normalize roughly to [-1, 1]
  //
  //    return combinedNoise * noise.displayed
  //  }

  //  private func noiseContribution(elapsed: CGFloat) -> CGFloat {
  //    guard noise.displayed != 0 else { return 0 }
  //
  //    let seed = noiseSeed
  //    //    let seed = noiseSeed &+ UInt64(elapsed * 100)
  //    let randomSource = GKMersenneTwisterRandomSource(seed: UInt64(seed))
  //
  //    let randomValue = { CGFloat(randomSource.nextInt(upperBound: 1000)) / 1000.0 }
  //
  //    //    var generator = RandomNumberGenerator()
  //    //    var generator = RandomValueGenerator<CGFloat>(seed: seed)
  //    ////    var generator = SystemRandomNumberGenerator()
  //    ////    generator.
  //    //    generator.seed = seed
  //
  //    //    let generator = SeededGenerator(seed: seed)
  //    //    let randomValue = CGFloat(generator.next())
  //
  //    //
  //    //    let randomValue = CGFloat.generate(
  //    //      count: 1,
  //    //      using: &generator
  //    //    )
  //    ////    let randomValue = CGFloat.random(in: -1...1, using: &generator)
  //    return randomValue() * noise.displayed
  //  }

//    private func noiseContribution(elapsed: CGFloat) -> CGFloat {
//      guard noise.displayed != 0 else { return 0 }
//      return (CGFloat.random(in: -1...1) * noise.displayed)
//    }

  private static let validRange: ClosedRange<CGFloat> = -1...1

}
