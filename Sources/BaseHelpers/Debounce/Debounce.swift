//
//  Debouncer.swift
//  Utilities
//
//  Created by Dave Coleman on 25/8/2024.
//

import Foundation

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
