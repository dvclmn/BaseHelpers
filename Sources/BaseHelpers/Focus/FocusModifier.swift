//
//  FocusModifier.swift
//  Collection
//
//  Created by Dave Coleman on 15/10/2024.
//

import SwiftUI

public enum FocusAction {
  case submit
  case exit
}

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
  
  public typealias Action = (FocusAction) -> Void
  
  /// This is neccesary local binding State, required by SwiftUI. Which
  /// must then be synced up to TCA via the `.bind()` modifier they supply
  @FocusState var focused: Item?
  
  /// Don't know if this will work. But this should bind with the focus
  /// property held by the TCA Reducer, in turn held by the app using
  /// this Modifier.
  @Binding var storeFocus: Item?
  
  /// And this is provided by the View, to specify which focusable item
  /// (e.g. sidebar renaming field) is being handled by this Modifier instance.
  let focusElement: Item
  let shouldFocusOnAppear: Bool
  let onAction: Action
  
  public init(
    storeFocus: Binding<Item?>,
    focusElement: Item,
    shouldFocusOnAppear: Bool = false,
    onAction: @escaping Action
  ) {
    self._storeFocus = storeFocus
    self.focusElement = focusElement
    self.shouldFocusOnAppear = shouldFocusOnAppear
    self.onAction = onAction
  }
  
  public func body(content: Content) -> some View {
    
    content
      .focusable()
      .focusEffectDisabled()
      .focused($focused, equals: focusElement)
      .onSubmit {
        onAction(.submit)
      }
      .onExitCommand {
        onAction(.exit)
      }
      .onAppear {
        if shouldFocusOnAppear {
          DispatchQueue.main.async {
            focused = focusElement
          }
        }
      }
      .task(id: focusElement) {
        print("Focused element: \(focusElement.name). Focused @ \(Date.now.friendlyDateAndTime)")
      }
      .bind($storeFocus, to: $focused)
  }
}

public extension View {
  
  /// This modifier provides a convenient way to set up common focus-related
  /// behaviours, such as enabling `.focusable`, focusing `onAppear`,
  /// `onExitCommand` (pressing Esc), disabling the focus effect, etc.
  ///
  func focusHelper<Item: FocusableItem>(
    storeFocus: Binding<Item?>,
    /// Provide the modifier with a single Item, from a `FocusableItem`
    /// conforming enum, e.g.: `FocusElement.sidebar(.rename)`
    element: Item,
    shouldFocusOnAppear: Bool = true,
    onAction: @escaping FocusHelper.Action = { _ in }
  ) -> some View {
    self.modifier(
      FocusHelper(
        storeFocus: storeFocus,
        focusElement: element,
        shouldFocusOnAppear: shouldFocusOnAppear,
        onAction: onAction
      )
    )
  }
}

