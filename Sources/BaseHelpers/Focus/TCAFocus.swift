//
//  Focus.swift
//  Collection
//
//  Created by Dave Coleman on 3/2/2025.
//

import SwiftUI

/// From TCA
extension View {
  /// Synchronizes model state to view state via two-way bindings.
  ///
  /// SwiftUI comes with many property wrappers that can be used in views to drive view state,
  /// like field focus. Unfortunately, these property wrappers _must_ be used in views. It's not
  /// possible to extract this logic to an `@Observable` class and integrate it with the rest of
  /// the model's business logic, and be in a better position to test this state.
  ///
  /// We can work around these limitations by introducing a published field to your observable
  /// object and synchronizing it to view state with this view modifier.
  ///
  /// - Parameters:
  ///   - modelValue: A binding from model state. _E.g._, a binding derived from a field
  ///     on an observable class.
  ///   - viewValue: A binding from view state. _E.g._, a focus binding.
  //  @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
  public func bind<ModelValue: _Bindable, ViewValue: _Bindable>(
    _ modelValue: ModelValue, to viewValue: ViewValue
  ) -> some View
  where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
    self.modifier(_Bind(modelValue: modelValue, viewValue: viewValue))
  }
}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
private struct _Bind<ModelValue: _Bindable, ViewValue: _Bindable>: ViewModifier
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
        print("View focus value `\(self.viewValue.wrappedValue)` updated to match Model focus value `\(self.modelValue.wrappedValue)`.")
      }
      .onChange(of: self.modelValue.wrappedValue) { _, newValue in
        guard self.viewValue.wrappedValue != newValue
        else { return }
        self.viewValue.wrappedValue = newValue
        print("Model focus value changed. Updated View focus value (previously `\(self.viewValue.wrappedValue)`) to match: `\(newValue)`.")
      }
      .onChange(of: self.viewValue.wrappedValue) { _, newValue in
        guard self.modelValue.wrappedValue != newValue
        else { return }
        self.modelValue.wrappedValue = newValue
        print("View focus value changed. Updated Model focus value (previously `\(self.modelValue.wrappedValue)`) to match: `\(newValue)`.")
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
