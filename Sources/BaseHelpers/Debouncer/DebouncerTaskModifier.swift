//
//  DebounceTaskModifier.swift
//  Collection
//
//  Created by Dave Coleman on 22/9/2024.
//

import SwiftUI

public struct DebouncingTaskViewModifier<ID: Equatable>: ViewModifier {
  let id: ID
  let priority: TaskPriority
  let seconds: TimeInterval
  let task: @Sendable () async -> Void
  
  public init(
    id: ID,
    priority: TaskPriority,
    seconds: TimeInterval,
    task: @Sendable @escaping () async -> Void
  ) {
    self.id = id
    self.priority = priority
    self.seconds = seconds
    self.task = task
  }
  
  public func body(content: Content) -> some View {
    content.task(id: id, priority: priority) {
      do {
        try await Task.sleep(for: .seconds(seconds))
        await task()
      } catch {
        // Ignore cancellation
      }
    }
  }
}


public extension View {
  func task<ID: Equatable>(
    id: ID,
    priority: TaskPriority = .userInitiated,
    seconds: TimeInterval = 0.2,
    task: @Sendable @escaping () async -> Void
  ) -> some View {
    modifier(
      DebouncingTaskViewModifier(
        id: id,
        priority: priority,
        seconds: seconds,
        task: task
      )
    )
  }
}
