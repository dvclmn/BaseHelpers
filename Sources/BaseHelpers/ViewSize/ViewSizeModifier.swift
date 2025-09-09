//
//  ViewSizeModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public typealias ViewSizeOutput = (CGSize) -> Void

public struct ViewSizeModifier: ViewModifier {

  @State private var debouncer: AsyncDebouncer?
  let valueOutput: ViewSizeOutput

  // MARK: - Initialiser
  public init(
    mode: DebounceMode,
    valueOutput: @escaping ViewSizeOutput
  ) {
    switch mode {
      case .debounce(let interval):
        self._debouncer = State(initialValue: AsyncDebouncer(interval: interval))
      case .noDebounce:
        self._debouncer = State(initialValue: nil)
    }
    self.valueOutput = valueOutput
  }

  // MARK: - View Modifier
  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: CGSize.self) { proxy in
        return proxy.size
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
  public func viewSize(
    mode debounceMode: DebounceMode,
    valueOutput: @escaping ViewSizeOutput,
  ) -> some View {
    self.modifier(
      ViewSizeModifier(
        mode: debounceMode,
        valueOutput: valueOutput
      )
    )
  }
}
