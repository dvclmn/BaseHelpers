//
//  TouchesNSView.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit

/// The underlying AppKit NSView that captures raw trackpad touches
public class TrackpadTouchesNSView: NSView {

  /// Touch manager to handle touch tracking and velocity calculation
  private let touchManager = TrackpadTouchManager()

  let didUpdateTouches: TouchOutput

  private var latestPressure: CGFloat = 1.0

  public init(
    didUpdateTouches: @escaping TouchOutput
  ) {
    self.didUpdateTouches = didUpdateTouches
    super.init(frame: .zero)
    self.setupView()
  }

  required init?(coder: NSCoder) {
    self.didUpdateTouches = { _ in }
    super.init(coder: coder)
  }

  private func setupView() {
    /// Direct == touches made directly onto a screen, like a Wacom
    /// Indirect == touches made on a device like a trackpad
    allowedTouchTypes = [.indirect]

    self.pressureConfiguration = NSPressureConfiguration(pressureBehavior: .primaryGeneric)

    /// Include stationary touches in the updates
    wantsRestingTouches = true

  }

  private func processFirstTouches(with event: NSEvent) {

    let nsTouches = event.allTouches()

    /// Note: Could create a pressure decay model
    /// Avoid pressure values staying artificially high after a hard press,
    /// Could implement a lightweight decay or smoothing filter (e.g., exponential smoothing toward 1.0 when idle).
    let processedTouches = touchManager.processCapturedTouches(
      nsTouches,
      timestamp: event.timestamp,
      pressure: latestPressure  // pass latest known
    )
    
    didUpdateTouches(processedTouches)

  }

  // MARK: - Touch Event Handlers
  public override func touchesBegan(with event: NSEvent) {
    processFirstTouches(with: event)
  }
  public override func touchesMoved(with event: NSEvent) {
    processFirstTouches(with: event)
  }

  public override func touchesEnded(with event: NSEvent) {
    processFirstTouches(with: event)
  }
  public override func touchesCancelled(with event: NSEvent) {
    processFirstTouches(with: event)
  }
  public override func pressureChange(with event: NSEvent) {
    latestPressure = CGFloat(event.pressure)
  }
}

extension NSTouch {
  func debuggingString(
    timestamp: TimeInterval,
    pressure: CGFloat
  ) -> String {
    """
    ////
    Received `NSTouch`
      - Phase: \(self.phase)
      - ID: \(self.identity)
      - ID Hash: \(self.identity.hash)
      - Is Resting: \(self.isResting)
      - Device: \(self.device.debugDescription)
      - Device Size: \(self.deviceSize)

      From NSEvent:
      - Timestamp: \(timestamp)
      - Pressure: \(pressure)
    """
  }
}
