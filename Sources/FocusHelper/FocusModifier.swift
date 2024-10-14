//
//  FocusModifier.swift
//  Collection
//
//  Created by Dave Coleman on 14/10/2024.
//

import SwiftUI
import ComposableArchitecture

/// IMPORTANT: For `onAppear` focus to work, make sure this modifier
/// is applied to a view that is *within* a conditional, that only shows this
/// view when the condition is met etc.
///
/// The key is, if this modifier is applied to a view that's *already entered*
/// the view hierarchy, then `onAppear` will already have been called,
/// at an earlier/irrelevant time.
///
//struct FocusHelper<FocusElement, State, Action>: ViewModifier where FocusElement: Hashable, State: Equatable, Action: BindableAction {
//  
//  @FocusState var focused: FocusElement?
//  @Bindable var focusStore: Store<State, Action>
//  
//  let focusElement: FocusElement
//  let shouldFocusOnAppear: Bool
//  
//  let onExitAction: () -> Void
//  
//  public func body(content: Content) -> some View {
//    content
//      .focusable()
//      .focusEffectDisabled()
//      .focused($focused, equals: focusElement)
//      .onAppear {
//        if shouldFocusOnAppear {
//          DispatchQueue.main.async {
//            focused = focusElement
//          }
//        }
//      }
//      .onExitCommand {
//        onExitAction()
//      }
//      .bind($focusStore.focusedElement, to: $focused)
//  }
//}
//
//extension View {
//  func focusHelper<FocusElement: Hashable>(
//    store: StoreOf<Focus>,
//    element: FocusElement,
//    shouldFocusOnAppear: Bool = true,
//    onExit: @escaping () -> Void = {}
//  ) -> some View {
//    self.modifier(
//      FocusHelper(
//        focusStore: store,
//        focusElement: element,
//        shouldFocusOnAppear: shouldFocusOnAppear,
//        onExitAction: onExit
//      )
//    )
//  }
//}
