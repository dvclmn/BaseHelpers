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
public struct FocusHelper<FocusableItem: Hashable>: ViewModifier {
  
  @FocusState var focused: FocusableItem?
  let focusStore: StoreOf<Focus<FocusableItem>>
  
  let focusElement: FocusableItem
  let shouldFocusOnAppear: Bool
  
  let onExitAction: () -> Void
  
  public func body(content: Content) -> some View {
    
    @Bindable var focusStore = focusStore
    
    content
      .focusable()
      .focusEffectDisabled()
      .focused($focused, equals: focusElement)
      .onAppear {
        if shouldFocusOnAppear {
          DispatchQueue.main.async {
            focused = focusElement
          }
        }
      }
      .onExitCommand {
        onExitAction()
      }
      .bind($focusStore.focusedElement, to: $focused)
  }
}

extension View {
  func focusHelper<FocusableItem: Hashable>(
    
    element: FocusableItem,
    shouldFocusOnAppear: Bool = true,
    onExit: @escaping () -> Void = {}
  ) -> some View {
    self.modifier(
      FocusHelper(
        
        focusElement: element,
        shouldFocusOnAppear: shouldFocusOnAppear,
        onExitAction: onExit
      )
    )
  }
}



@Reducer
public struct Focus<FocusableItem: Hashable> {
  
  @ObservableState
  public struct State: Equatable, Sendable {
    
    var focusedElement: FocusableItem?
    
    public init(
      focusedElement: FocusableItem? = nil
    ) {
      self.focusedElement = focusedElement
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerOf<Self> {
    
    BindingReducer()
    Reduce { state, action in
      
      switch action {
        case .binding:
          return .none
      }
      
    }
    //    ._printChanges()
  }
  
}

