//
//  HandlerBindable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import SwiftUI

extension View {
  public func bind<Value: Equatable>(
    _ lhs: Binding<Value>,
    to rhs: Binding<Value>
  ) -> some View {
    self.modifier(TwoWayBind(lhs: lhs, rhs: rhs))
  }
}

private struct TwoWayBind<Value: Equatable>: ViewModifier {

  @State var hasAppeared = false

  let lhs: Binding<Value>
  let rhs: Binding<Value>

  func body(content: Content) -> some View {
    content
      .onAppear {
        guard !self.hasAppeared else { return }
        self.hasAppeared = true
        updateIfChanged(&lhs.wrappedValue, to: rhs.wrappedValue)
      }
      .onChange(of: lhs.wrappedValue) { _, new in
        updateIfChanged(&rhs.wrappedValue, to: new)
      }
      .onChange(of: rhs.wrappedValue) { _, new in
        updateIfChanged(&lhs.wrappedValue, to: new)
      }
  }
}

//extension View {
//
//  public func bindHandler<HandlerValue: _Bindable, ViewValue: _Bindable>(
//    _ handlerValue: HandlerValue,
//    to viewValue: ViewValue
//  ) -> some View
//  where
//    HandlerValue.Value == ViewValue.Value,
//    HandlerValue.Value: Equatable
//  {
//    self.modifier(Bind(handlerValue: handlerValue, viewValue: viewValue))
//  }
//}
//
//private struct Bind<HandlerValue: _Bindable, ViewValue: _Bindable>: ViewModifier
//where HandlerValue.Value == ViewValue.Value, HandlerValue.Value: Equatable {
//  let handlerValue: HandlerValue
//  let viewValue: ViewValue
//
//  @State var hasAppeared = false
//
//  func body(content: Content) -> some View {
//    content
//      .onAppear {
//        guard !self.hasAppeared else { return }
//        self.hasAppeared = true
//        guard self.viewValue.wrappedValue != self.handlerValue.wrappedValue else { return }
//        self.viewValue.wrappedValue = self.handlerValue.wrappedValue
//        print(
//          "View focus value `\(self.viewValue.wrappedValue)` updated to match Model focus value `\(self.handlerValue.wrappedValue)`."
//        )
//      }
//      .onChange(of: self.handlerValue.wrappedValue) { _, newValue in
//        guard self.viewValue.wrappedValue != newValue
//        else { return }
//        self.viewValue.wrappedValue = newValue
//        print(
//          "Model focus value changed. Updated View focus value (previously `\(self.viewValue.wrappedValue)`) to match: `\(newValue)`."
//        )
//      }
//      .onChange(of: self.viewValue.wrappedValue) { _, newValue in
//        guard self.handlerValue.wrappedValue != newValue
//        else { return }
//        self.handlerValue.wrappedValue = newValue
//        print(
//          "View focus value changed. Updated Model focus value (previously `\(self.handlerValue.wrappedValue)`) to match: `\(newValue)`."
//        )
//      }
//  }
//}
