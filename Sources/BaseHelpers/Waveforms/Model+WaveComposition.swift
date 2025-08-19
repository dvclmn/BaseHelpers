//
//  Model+WaveComposition.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation


/// Encapsulates the “how do these waves combine?” logic.
/// Simply has the ability to take in 2 or more Waves, and
/// create a combined/single Composition.
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
  
  public func wavesForEffect(from library: [Wave]) -> [Wave] {
    let waveLibrary = Dictionary(uniqueKeysWithValues: library.map { ($0.id, $0) })
    return waves.compactMap { waveLibrary[$0] }
  }
  
  public func value(
    elapsed: CGFloat,
    //    at phase: CGFloat,
    from library: [Wave]
    //    from library: IdentifiedArrayOf<Wave>
    //    from library: [Wave.ID: Wave]
  ) -> CGFloat {
    
    let wavesForEffect = wavesForEffect(from: library)
    let waveValues: [CGFloat] = wavesForEffect.map { wave in
      wave.value(elapsed: elapsed)
    }
    //    let waveValues: [CGFloat] = library.compactMap { wave in
    //      library[id: wave.id]?.value(elapsed: elapsed)
    //      //      wave.value(elapsed: elapsed)
    //    }
    
    /// Handle empty case
    guard !waveValues.isEmpty else { return 0 }
    
    /// Blend according to mode
    switch mode {
      case .add:
        return waveValues.reduce(0, +)
        
      case .multiply:
        return waveValues.reduce(1, *)
        
      case .max:
        return waveValues.max() ?? 0
        
      case .min:
        return waveValues.min() ?? 0
        
      case .weighted(let weights):
        // zip values and weights, multiply, then sum
        let pairs = zip(waveValues, weights)
        let weightedSum = pairs.reduce(0) { acc, pair in
          let (val, weight) = pair
          return acc + (val * weight)
        }
        // normalise by sum of weights if that’s desired,
        // or leave raw if you want scaling behaviour
        let totalWeight = weights.prefix(waveValues.count).reduce(0, +)
        return totalWeight > 0 ? weightedSum / totalWeight : 0
    }
  }
}

public enum WaveBlendMode: Documentable {
  case add
  case multiply
  case max
  case min
  case weighted([CGFloat])  // optional weights
}
