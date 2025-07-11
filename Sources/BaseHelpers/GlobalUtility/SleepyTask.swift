//
//  SleepyTask.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/7/2025.
//

import Foundation

public func sleepyTask(
  interval: TimeInterval = 1,
  _ task: @Sendable @escaping () -> Void,
//  _ task: @Sendable @escaping () -> Void,
) {
  Task { @MainActor in
    do {
      try await Task.sleep(for: .seconds(interval))
      task()
    } catch {
      // Wait
    }
  }
}
