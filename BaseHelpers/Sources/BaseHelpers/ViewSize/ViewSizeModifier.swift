//
//  ViewSizeModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public typealias ViewSizeOutput<T> = (T) -> Void

public struct ViewSizeModifier<CaptureType: GeometryCapturable>: ViewModifier {

  @State private var debouncer: AsyncDebouncer?
  
  let capture: GeometryCapture<CaptureType>
  let valueOutput: ViewSizeOutput<CaptureType>

  // MARK: - Initialiser
  public init(
    capture: GeometryCapture<CaptureType>,
    mode: DebounceMode,
    valueOutput: @escaping ViewSizeOutput<CaptureType>
  ) {
    switch mode {
      case .debounce(let interval):
        self._debouncer = State(initialValue: AsyncDebouncer(interval: interval))
      case .noDebounce:
        self._debouncer = State(initialValue: nil)
    }
    self.capture = capture
    self.valueOutput = valueOutput
  }

  // MARK: - View Modifier
  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: capture.type) { proxy in
        return capture.transform(proxy)

      } action: { newValue in
        Task {
          if let debouncer {
            await debouncer.execute { @MainActor in
              valueOutput(newValue)
            }
          } else {
            valueOutput(newValue)
          }
        }
      }
  }
}

// MARK: - View Extension
extension View {
  /// Previously had default value for `debounceMode`, but this felt
  /// too risky for domains that may be tripped up by immediate vs debounced
  public func viewSize<T: GeometryCapturable>(
    capture: GeometryCapture<T> = .size,
    mode debounceMode: DebounceMode,
    valueOutput: @escaping ViewSizeOutput<T>,
  ) -> some View {
    self.modifier(
      ViewSizeModifier(
        capture: capture,
        mode: debounceMode,
        valueOutput: valueOutput
      )
    )
  }
}
