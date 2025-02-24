//
//  Debouncer.swift
//  Utilities
//
//  Created by Dave Coleman on 25/8/2024.
//

import Foundation
import SwiftUI


@MainActor
public final class DebounceValue<T: Equatable> {
  
  private(set) var value: T {
    didSet {
      guard oldValue != value else { return }
      valueChanged?(value)
    }
  }
  
  var valueChanged: ((T) -> Void)?
  
  private var task: Task<Void, Never>?
  private let interval: Duration
//  private let scheduler: DebounceScheduler

  public init(
    _ value: T,
    interval: Duration = .seconds(0.2)
//    scheduler: DebounceScheduler = MainScheduler()
  ) {
    self.value = value
    self.interval = interval
//    self.scheduler = scheduler
  }
  
  public func update(with newValue: T) {
    guard newValue != value else { return }
    task?.cancel()
    task = Task { [weak self] in
      guard let self else { return }
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

/// Protocol for testing and dependency injection
public protocol DebounceScheduler {
  func schedule(for duration: Duration) async throws
}

/// Default implementation using Task.sleep
//public struct MainScheduler: DebounceScheduler {
//  public func schedule(for duration: Duration) async throws {
//    try await Task.sleep(for: duration)
//  }
//  public init
//}

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
//public actor Debouncer {
//  private var task: Task<Void, Never>?
//  private let interval: TimeInterval
//  
//  public init(interval: TimeInterval = 0.1) {
//    self.interval = interval
//  }
//  
//  public func processTask(action: @escaping @Sendable () async -> Void) {
//    task?.cancel()
//    task = Task { [weak self, action] in
//      guard let self = self else { return }
//      do {
//        try await Task.sleep(for: .seconds(self.interval))
//        if !Task.isCancelled {
//          await action()
//        }
//      } catch {
//        // Handle cancellation or other errors
//      }
//    }
//  }
//}
//



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
