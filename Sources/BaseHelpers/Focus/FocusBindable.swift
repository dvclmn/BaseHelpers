//
//  Focus.swift
//  Collection
//
//  Created by Dave Coleman on 3/2/2025.
//

import SwiftUI

/// Note: This is directly inspired by Point-Free's implementation in
/// https://github.com/pointfreeco/swift-composable-architecture
///
/// I make no claim over the logic behind this solution.

public protocol FocusBindable {
  associatedtype Value
  var wrappedValue: Value { get nonmutating set }
}

extension Binding: FocusBindable {}
extension FocusedBinding: FocusBindable {}
extension FocusState: FocusBindable {}
extension FocusState.Binding: FocusBindable {}

extension View {

  public func focusBinding<ModelValue: FocusBindable, ViewValue: FocusBindable>(
    _ modelValue: ModelValue,
    to viewValue: ViewValue
  ) -> some View
  where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
    self.modifier(BindFocus(modelValue: modelValue, viewValue: viewValue))
  }
}

private struct BindFocus<ModelValue: FocusBindable, ViewValue: FocusBindable>: ViewModifier
where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
  let modelValue: ModelValue
  let viewValue: ViewValue

  @State var hasAppeared = false

  func body(content: Content) -> some View {
    content
      .onAppear {
        guard !self.hasAppeared else { return }
        self.hasAppeared = true
        guard self.viewValue.wrappedValue != self.modelValue.wrappedValue else { return }
        self.viewValue.wrappedValue = self.modelValue.wrappedValue
        print(
          "View focus value `\(self.viewValue.wrappedValue)` updated to match Model focus value `\(self.modelValue.wrappedValue)`."
        )
      }
      .onChange(of: self.modelValue.wrappedValue) { _, newValue in
        guard self.viewValue.wrappedValue != newValue
        else { return }
        self.viewValue.wrappedValue = newValue
        print(
          "Model focus value changed. Updated View focus value (previously `\(self.viewValue.wrappedValue)`) to match: `\(newValue)`."
        )
      }
      .onChange(of: self.viewValue.wrappedValue) { _, newValue in
        guard self.modelValue.wrappedValue != newValue
        else { return }
        self.modelValue.wrappedValue = newValue
        print(
          "View focus value changed. Updated Model focus value (previously `\(self.modelValue.wrappedValue)`) to match: `\(newValue)`."
        )
      }
  }
}
