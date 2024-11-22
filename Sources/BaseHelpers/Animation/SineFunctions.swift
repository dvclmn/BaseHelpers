//
//  SineFunctions.swift
//  Collection
//
//  Created by Dave Coleman on 21/11/2024.
//

import Foundation

public struct Sine {
  
  /// If you want [-1, 1] range instead:
  /// `let value = sine // Skip normalization`
  ///
  /// If you want a custom range [min, max]:
  /// ```
  /// let min: Double = 10
  /// let max: Double = 20
  /// let customRange = normalized * (max - min) + min
  /// ```
  ///
  /// If you want to use cosine instead (90° phase shift):
  /// `let cosine = cos(interval * angularFrequency)`
  ///
  /// If you want to adjust the amplitude:
  /// ```
  /// let amplitude = 0.5 // Less than 1 for smaller range
  /// let modifiedSine = sin(interval * angularFrequency) * amplitude
  /// ```

  public static func getSineWave(from interval: TimeInterval, frequency: Double = 0.2) -> Double {
    
    /// 2. Define your frequency (controls speed of oscillation)
    /// Lower numbers = slower oscillation
    /// Higher numbers = faster oscillation
    
    /// 3. Create the angular frequency (radians per second)
    let angularFrequency = 2 * Double.pi * frequency
    
    /// 4. Calculate the sine wave
    let sine = sin(interval * angularFrequency)
    
    /// 5. Normalize from [-1, 1] to [0, 1]
//    let normalised = (sine + 1) / 2
    
    return sine
    
  }
  
  public static func getSineWave(from date: Date, frequency: Double = 0.2) -> Double {
    /// 1. Get the time interval (seconds since reference date)
    let interval = date.timeIntervalSinceReferenceDate
    
    return getSineWave(from: interval, frequency: frequency)
    
  }
  
  
  
}
