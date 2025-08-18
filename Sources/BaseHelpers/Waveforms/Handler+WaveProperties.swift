//
//  Handler+WaveProperties.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

public struct Wave: Documentable, Identifiable {
  public let id: UUID
  public var frequency: SmoothedProperty
  public var amplitude: SmoothedProperty
  public var phaseOffset: SmoothedProperty
  public var noise: SmoothedProperty

  
  public func value(
    at phase: CGFloat
      //    at time: TimeInterval
  ) -> CGFloat {
    let base = sin(phase + phaseOffset.displayed)
    let noisy = base + (noise.displayed * CGFloat.randomNoise())
    return amplitude.displayed * noisy
  }

}

public enum WaveBlendMode: Documentable {
  case add
  case multiply
  case max
  case min
  case weighted([CGFloat])  // optional weights
}

///  encapsulates the “how do these waves combine?” logic.
public struct WaveComposition: Documentable {
  var waves: [Wave.ID]
  var mode: WaveBlendMode

  public init(
    waves: [Wave.ID] = [],
    mode: WaveBlendMode = .add
  ) {
    self.waves = waves
    self.mode = mode
  }

  func value(at time: TimeInterval, from library: [Wave.ID: Wave]) -> CGFloat {
    let values = waves.compactMap { library[$0]?.value(at: time) }
    
    #warning("Not actually sure how to implement this")
    return values.reduce(0, +)
    // reduce according to mode
  }
}

public struct SmoothedProperty: Documentable {
  public var target: CGFloat
  public var displayed: CGFloat

  public init(_ initial: CGFloat) {
    self.target = initial
    self.displayed = initial
  }

  public mutating func update(
    dt: CGFloat,
    timeConstant: CGFloat
  ) {
    displayed = displayed.smoothed(
      towards: target,
      dt: dt,
      timeConstant: timeConstant
    )
  }
}

extension Dictionary where Key: CaseIterable, Value == SmoothedProperty {
  public mutating func updateAll(dt: CGFloat, timeConstant: CGFloat) {
    for key in Key.allCases {
      self[key]?.update(dt: dt, timeConstant: timeConstant)
    }
  }
}

//@MainActor
public struct WaveProperties: Sendable, Equatable {
  //  public var engine = Engine()
  //  public var shape = Shape()
  //
  //  public init() {}

  public var engine: [WaveEngineProperty: SmoothedProperty]
  public var shape: [WaveShapeProperty: SmoothedProperty]

  public init() {
    engine = Dictionary(uniqueKeysWithValues: WaveEngineProperty.allCases.map { ($0, .init($0.defaultValue)) })
    shape = Dictionary(uniqueKeysWithValues: WaveShapeProperty.allCases.map { ($0, .init($0.defaultValue)) })
  }
}

//extension WaveProperties {
//  // MARK: - Engine domain
//  /// The oscillating CGFloat wave value, used to drive animated effects
//  //  @MainActor
//  public struct Engine: Sendable, Equatable {
//    public var targetAmplitude: CGFloat = WaveEngineProperty.amplitude.defaultValue
//    public var targetFrequency: CGFloat = WaveEngineProperty.frequency.defaultValue
//    public var targetNoise: CGFloat = WaveEngineProperty.noise.defaultValue
//    public var targetPhaseOffset: CGFloat = WaveEngineProperty.phaseOffset.defaultValue
//
//    public var displayedAmplitude: CGFloat = .zero
//    public var displayedFrequency: CGFloat = .zero
//    public var displayedNoise: CGFloat = .zero
//    public var displayedPhaseOffset: CGFloat = .zero
//  }
//
//  // MARK: - Shape domain
//  /// How the wave is drawn to the Canvas, for visualisation in the UI
//  //  @MainActor
//  public struct Shape: Sendable, Equatable {
//    public var targetCyclesAcross: CGFloat = WaveShapeProperty.cyclesAcross.defaultValue
//    public var displayedCyclesAcross: CGFloat = .zero
//  }
//}

//extension WaveProperties.Engine {
// public mutating func updateProperty(
//    _ property: WaveEngineProperty,
//    dt: CGFloat,
//    timeConstant: CGFloat
//  ) {
//    let currentValue = self[keyPath: property.displayedKeyPath]
//    let targetValue = self[keyPath: property.targetKeyPath]
//
//    self[keyPath: property.displayedKeyPath] = currentValue.smoothed(
//      towards: targetValue,
//      dt: dt,
//      timeConstant: timeConstant
//    )
//  }
//}
//
//extension WaveProperties.Shape {
//  public mutating func updateProperty(
//    _ property: WaveShapeProperty,
//    dt: CGFloat,
//    timeConstant: CGFloat
//  ) {
//    let currentValue = self[keyPath: property.displayedKeyPath]
//    let targetValue = self[keyPath: property.targetKeyPath]
//
//    self[keyPath: property.displayedKeyPath] = currentValue.smoothed(
//      towards: targetValue,
//      dt: dt,
//      timeConstant: timeConstant
//    )
//  }
//}
