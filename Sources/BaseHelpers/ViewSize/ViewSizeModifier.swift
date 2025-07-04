//
//  ViewSizeModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public typealias ViewSizeOutput = (CGSize) -> Void
public typealias ViewLengthOutput = (CGFloat) -> Void

/// `CGSize`, for width and height of view
public struct ViewSizeModifier: ViewModifier {
  @State private var debouncer: AsyncDebouncer?
  let valueOutput: ViewSizeOutput
  public init(
    shouldDebounce: Bool,
    debounceInterval: Double,
    valueOutput: @escaping ViewSizeOutput
  ) {
    self._debouncer = State(initialValue: shouldDebounce ? AsyncDebouncer(interval: debounceInterval) : nil)
    self.valueOutput = valueOutput
  }

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

/// `CGFloat`, for just width, or just height
public struct ViewLengthModifier: ViewModifier {

  private let debouncer: AsyncDebouncer?

  let axis: Axis
  let valueOutput: ViewLengthOutput

  public init(
    axis: Axis,
    shouldDebounce: Bool,
    valueOutput: @escaping ViewLengthOutput
  ) {
    self.debouncer = shouldDebounce ? AsyncDebouncer() : nil
    self.axis = axis
    self.valueOutput = valueOutput
  }

  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: CGFloat.self) { proxy in
        switch axis {
          case .horizontal:
            return proxy.size.width

          case .vertical:
            return proxy.size.height
        }
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
      }  // END geom change modifier

  }
}
extension View {
  public func viewLength(
    _ axis: Axis = .horizontal,
    shouldDebounce: Bool = true,
    valueOutput: @escaping ViewLengthOutput
  ) -> some View {
    self.modifier(
      ViewLengthModifier(
        axis: axis,
        shouldDebounce: shouldDebounce,
        valueOutput: valueOutput
      )
    )
  }

  public func viewSize(
    shouldDebounce: Bool = true,
    debounceInterval: Double = 0.1,
    valueOutput: @escaping ViewSizeOutput,
  ) -> some View {
    self.modifier(
      ViewSizeModifier(
        shouldDebounce: shouldDebounce,
        debounceInterval: debounceInterval,
        valueOutput: valueOutput
      )
    )
  }
}
