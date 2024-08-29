//
//  Debouncer.swift
//  Utilities
//
//  Created by Dave Coleman on 25/8/2024.
//

import Dependencies
import SwiftUI

//public extension DependencyValues {
//  var windowDimensions: WindowSizeHandler {
//    get { self[WindowSizeHandler.self] }
//    set { self[WindowSizeHandler.self] = newValue }
//  }
//}
//
//extension WindowSizeHandler: DependencyKey {
//  public static let liveValue = WindowSizeHandler()
//  public static var testValue = WindowSizeHandler()
//}
//
//@Observable
//public class WindowSizeHandler {
//  
//  public var width: CGFloat
//  public var height: CGFloat
//  
//  public init(
//    width: CGFloat = .zero,
//    height: CGFloat = .zero
//  ) {
//    self.width = width
//    self.height = height
//  }
//}
//
//public struct WindowSizeModifier: ViewModifier {
//  @Dependency(\.windowDimensions) var windowSize
//  
//  public func body(content: Content) -> some View {
//    content
//      .background(
//        GeometryReader { geometry in
//          Color.clear
//            .task(id: geometry.size) {
//              windowSize.width = geometry.size.width
//              windowSize.height = geometry.size.height
//            }
//        }
//      )
//  }
//}
//
//public extension View {
//  func readWindowSize() -> some View {
//    self.modifier(WindowSizeModifier())
//  }
//}


/// Example usage (seems like this could be improved)
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
  private let interval: Double
  
  public init(interval: Double = 0.1) {
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
