//
//  Handler+Waveform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

public typealias WaveTickOutput = (_ deltaTime: CGFloat) -> Void

@Observable
public final class WaveEngine {

  @ObservationIgnored
  private var startTime: CFTimeInterval?

  @ObservationIgnored
  private var lastWallClock: CFTimeInterval?

  /// Accumulated elapsed time since engine started (seconds)
  public var elapsed: CGFloat = 0

  public init() {}

}

extension WaveEngine {

  public func tick(
    now: CFTimeInterval,
    didUpdateTick: WaveTickOutput
  ) {
    /// initialise on first call
    if startTime == nil {
      startTime = now
      lastWallClock = now
      elapsed = 0
      return
    }

    guard let last = lastWallClock, let start = startTime else { return }

    /// delta between frames
    let dt = now - last
    lastWallClock = now

    didUpdateTick(CGFloat(dt))

    /// total elapsed since engine start
    elapsed = CGFloat(now - start)
  }
}
