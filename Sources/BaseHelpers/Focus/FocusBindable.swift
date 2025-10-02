//
//  Focus.swift
//  Collection
//
//  Created by Dave Coleman on 3/2/2025.
//

import SwiftUI

/// Note: This is directly taken from Point-Free's implementation in
/// https://github.com/pointfreeco/swift-composable-architecture
/// https://github.com/pointfreeco/swift-composable-architecture/blob/20089ee985b04b1ae82e9742aa9d9c8f044700c5/Examples/CaseStudies/SwiftUICaseStudies/01-GettingStarted-FocusState.swift#L71
///
/// I make no claim over the logic behind this solution.

extension View {

  public func focusBinding<ModelValue: _Bindable, ViewValue: _Bindable>(
    _ modelValue: ModelValue,
    to viewValue: ViewValue
  ) -> some View
  where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
    self.modifier(Bind(modelValue: modelValue, viewValue: viewValue))
  }
}

private struct Bind<ModelValue: _Bindable, ViewValue: _Bindable>: ViewModifier
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


public protocol _Bindable {
  associatedtype Value
  var wrappedValue: Value { get nonmutating set }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension AccessibilityFocusState: _Bindable {}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension AccessibilityFocusState.Binding: _Bindable {}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
extension AppStorage: _Bindable {}

extension Binding: _Bindable {}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
extension FocusedBinding: _Bindable {}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension FocusState: _Bindable {}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension FocusState.Binding: _Bindable {}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
extension SceneStorage: _Bindable {}

extension State: _Bindable {}
