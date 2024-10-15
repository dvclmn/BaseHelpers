//
//  FocusModifier.swift
//  Collection
//
//  Created by Dave Coleman on 14/10/2024.
//

import SwiftUI
import ComposableArchitecture
import BaseHelpers

public protocol FocusableItem: Hashable {
  var name: String { get }
}

/// IMPORTANT: For `onAppear` focus to work, make sure this modifier
/// is applied to a view that is *within* a conditional, that only shows this
/// view when the condition is met etc.
///
/// The key is, if this modifier is applied to a view that's *already entered*
/// the view hierarchy, then `onAppear` will already have been called,
/// at an earlier/irrelevant time.
///
public struct FocusHelper<Item: FocusableItem>: ViewModifier {
  
  @FocusState var focused: Item?
  let focusStore: StoreOf<Focus<Item>>
  
  /// 
  let focusElement: Item
  let shouldFocusOnAppear: Bool
  
  let onExitAction: () -> Void
  
  public init(
    focusElement: Item,
    shouldFocusOnAppear: Bool = false,
    onExitAction: @escaping () -> Void
  ) {
    self.focusElement = focusElement
    self.shouldFocusOnAppear = shouldFocusOnAppear
    self.onExitAction = onExitAction
    
    let store = Store(initialState: Focus<Item>.State()) {
      Focus<Item>()
    }
    
    self.focusStore = store
    
  }
  
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
      .task(id: focusElement) {
        print("Focused element: \(focusElement.name). Focused @ \(Date.now.friendlyDateAndTime)")
      }
  }
}

public extension View {
  func focusHelper<Item: FocusableItem>(
    
    element: Item,
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
public struct Focus<Item: FocusableItem> {
  
  @ObservableState
  public struct State: Equatable, Sendable {
    
    var focusedElement: Item?
    
    public init(
      focusedElement: Item? = nil
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

public extension DependencyValues {
  var windowDimensions: Focus {
    get { self[WindowSizeHandler.self] }
    set { self[WindowSizeHandler.self] = newValue }
  }
}

extension WindowSizeHandler: DependencyKey {
  public static let liveValue = WindowSizeHandler()
  public static let testValue = WindowSizeHandler()
}

