//
//  DebounceTaskModifier.swift
//  Collection
//
//  Created by Dave Coleman on 22/9/2024.
//

import SwiftUI

public struct DebouncedTaskViewModifier<ID: Equatable>: ViewModifier {
  @State private var debouncer: AsyncDebouncer
  let id: ID
  let interval: TimeInterval
  let action: () async -> Void
  
  public init(
    id: ID,
    interval: TimeInterval,
    action: @escaping @Sendable () async -> Void
  ) {
    self.id = id
    self.interval = interval
    self._debouncer = State(initialValue: AsyncDebouncer(interval: interval))
    self.action = action
  }
  public func body(content: Content) -> some View {
    content
      .task(id: id) {
        await debouncer.execute { @MainActor in
          await action()
        }
      }
  }
}
extension View {
  public func debouncedTask<ID: Equatable>(
    id: ID,
    interval: TimeInterval = 0.2,
    action: @escaping @Sendable () async -> Void
  ) -> some View {
    self.modifier(
      DebouncedTaskViewModifier(
        id: id,
        interval: interval,
        action: action
      )
    )
  }
}

//public struct DebouncingTaskViewModifier<ID: Equatable>: ViewModifier {
//  let id: ID
//  let priority: TaskPriority
//  let seconds: TimeInterval
//  let task: @Sendable () async -> Void
//  
//  public init(
//    id: ID,
//    priority: TaskPriority,
//    seconds: TimeInterval,
//    task: @Sendable @escaping () async -> Void
//  ) {
//    self.id = id
//    self.priority = priority
//    self.seconds = seconds
//    self.task = task
//  }
//  
//  public func body(content: Content) -> some View {
//    content.task(id: id, priority: priority) {
//      do {
//        try await Task.sleep(for: .seconds(seconds))
//        await task()
//      } catch {
//        // Ignore cancellation
//      }
//    }
//  }
//}
//
//
//
//public extension View {
//  func task<ID: Equatable>(
//    id: ID,
//    priority: TaskPriority = .userInitiated,
//    seconds: TimeInterval = 0.2,
//    task: @Sendable @escaping () async -> Void
//  ) -> some View {
//    modifier(
//      DebouncingTaskViewModifier(
//        id: id,
//        priority: priority,
//        seconds: seconds,
//        task: task
//      )
//    )
//  }
//}
