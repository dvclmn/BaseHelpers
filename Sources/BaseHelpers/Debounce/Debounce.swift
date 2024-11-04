//
//  Debouncer.swift
//  Utilities
//
//  Created by Dave Coleman on 25/8/2024.
//

import Foundation
import SwiftUI

//@Observable
@MainActor
public final class DebounceValue<T> {
  
  private(set) var value: T
  
  private var task: Task<Void, Never>?
  private let interval: Duration

  public init(
    _ value: T,
    interval: Duration = .seconds(0.2)
  ) {
    self.value = value
    self.interval = interval
  }
  
  public func update(with newValue: T) {
    task?.cancel()
    task = Task { @MainActor in
      
      do {
        try await Task.sleep(for: self.interval)
        if !Task.isCancelled {
          self.value = newValue
        }
      } catch {
        // Task cancelled, no action needed
      }
    }
  }
  
  deinit {
    task?.cancel()
  }
}

/// Example usage (seems like this could be improved)
///
/// ```
///    Task {
///      await heightHandler.processTask { [weak self] in
///
///        guard let self = self else { return }
///
///        let height = await self.generateEditorHeight()
///
///        Task { @MainActor in
///          await self.infoHandler.update(height)
///        }
///
///      } // END process scroll
///    } // END Task
/// ```
///
public actor Debouncer {
  private var task: Task<Void, Never>?
  private let interval: TimeInterval
  
  public init(interval: TimeInterval = 0.1) {
    self.interval = interval
  }
  
  public func processTask(action: @escaping @Sendable () async -> Void) {
    task?.cancel()
    task = Task { [weak self, action] in
      guard let self = self else { return }
      do {
        try await Task.sleep(for: .seconds(self.interval))
        if !Task.isCancelled {
          await action()
        }
      } catch {
        // Handle cancellation or other errors
      }
    }
  }
}




//@MainActor
//public final class DebounceValue<T> {
//  private var task: Task<Void, Never>?
//  private let interval: Duration
//  private var lastValue: T?
//  private let action: (T) -> Void
//  
//  public init(
//    interval: Duration = .seconds(0.2),
//    action: @Sendable @escaping (T) -> Void
//  ) {
//    self.interval = interval
//    self.action = action
//  }
//  
//  public func send(_ value: T) {
//    lastValue = value
//    task?.cancel()
//    task = Task { [weak self] in
//      guard let self = self else { return }
//      do {
//        try await Task.sleep(for: self.interval)
//        if !Task.isCancelled, let value = self.lastValue {
//          self.action(value)
//        }
//      } catch {
//        // Task cancelled, no action needed
//      }
//    }
//  }
//  
//  deinit {
//    task?.cancel()
//  }
//}
