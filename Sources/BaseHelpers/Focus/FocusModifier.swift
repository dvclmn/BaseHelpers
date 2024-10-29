//
//  FocusModifier.swift
//  Collection
//
//  Created by Dave Coleman on 15/10/2024.
//

import SwiftUI
import ComposableArchitecture

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
public struct TCAFocusHelper: ViewModifier {
  
  public typealias Action = (FocusAction) -> Void
  public typealias FocusItem = AnyHashable
  
  /// This is neccesary local binding State, required by SwiftUI. Which
  /// must then be synced up to TCA via the `.bind()` modifier they supply
  @FocusState private var viewFocus: FocusItem?
  
  /// This is here in case there's already a `@FocusState` established
  /// in the view, and the caller just wants the convenience of the default
  /// `onExit` behaviours, `focusable` already defined, etc.
  var viewFocusBinding: FocusState<FocusItem?>.Binding?
  
  /// Don't know if this will work. But this should bind with the focus
  /// property held by the TCA Reducer, in turn held by the app using
  /// this Modifier.
  @Binding var storeFocus: FocusItem?
  
  /// And this is provided by the View, to specify which focusable item
  /// (e.g. sidebar renaming field) is being handled by this Modifier instance.
//  let focusElement: Item
  let shouldFocusOnAppear: Bool
  let onAction: Action?
  
  public init(
    storeFocus: Binding<FocusItem?> = .constant(nil),
    viewFocusBinding: FocusState<FocusItem?>.Binding? = nil,
//    focusElement: Item,
    shouldFocusOnAppear: Bool = false,
    onAction: @escaping Action
  ) {
    self._storeFocus = storeFocus
//    self.focusElement = focusElement
    self.shouldFocusOnAppear = shouldFocusOnAppear
    self.onAction = onAction
  }
  
  public func body(content: Content) -> some View {
    
    content
      .focusable()
//      .focusEffectDisabled()
      .focused($viewFocus, equals: storeFocus)
      .onSubmit {
        if let onAction {
          onAction(.submit)
        }
      }
#if canImport(AppKit)
      .onExitCommand {
        if let onAction {
          onAction(.exit)
        } else {
          viewFocus = nil
        }
      }
    #endif
      .onAppear {
        if shouldFocusOnAppear {
          DispatchQueue.main.async {
            viewFocus = storeFocus
          }
        }
      }
//      .task(id: focusElement) {
//        print("Focused element: \(focusElement.name). Focused @ \(Date.now.friendlyDateAndTime)")
//      }
      .bind($storeFocus, to: $viewFocus)
  }
}



/// There should be another version for non-TCA



public extension View {
  
  /// This modifier provides a convenient way to set up common focus-related
  /// behaviours, such as enabling `.focusable`, focusing `onAppear`,
  /// `onExitCommand` (pressing Esc), disabling the focus effect, etc.
  ///
  func focusHelper(
    storeFocus: Binding<AnyHashable?>,
    /// Provide the modifier with a single Item, from a `FocusableItem`
    /// conforming enum, e.g.: `FocusElement.sidebar(.rename)`
//    element: Item,
    shouldFocusOnAppear: Bool = true,
    onAction: @escaping TCAFocusHelper.Action = { _ in }
  ) -> some View {
    self.modifier(
      TCAFocusHelper(
        storeFocus: storeFocus,
//        focusElement: element,
        shouldFocusOnAppear: shouldFocusOnAppear,
        onAction: onAction
      )
    )
  }
}


//
//
//
//
//public struct FocusHelper: ViewModifier {
//  
//  public typealias Action = (FocusAction) -> Void
//
//  /// This is here in case there's already a `@FocusState` established
//  /// in the view, and the caller just wants the convenience of the default
//  /// `onExit` behaviours, `focusable` already defined, etc.
//  var focused: FocusState<AnyHashable?>.Binding
//
//  /// And this is provided by the View, to specify which focusable item
//  /// (e.g. sidebar renaming field) is being handled by this Modifier instance.
//  //  let focusElement: Item
//  let shouldFocusOnAppear: Bool
//  let onAction: Action?
//  
//  public init(
//    _ focused: FocusState<AnyHashable?>.Binding,
//    shouldFocusOnAppear: Bool = false,
//    onAction: @escaping Action
//  ) {
//    self.focused = focused
//    //    self.focusElement = focusElement
//    self.shouldFocusOnAppear = shouldFocusOnAppear
//    self.onAction = onAction
//  }
//  
//  public func body(content: Content) -> some View {
//    
//    content
//      .focusable()
//    //      .focusEffectDisabled()
//      .focused($viewFocus, equals: storeFocus)
//      .onSubmit {
//        if let onAction {
//          onAction(.submit)
//        }
//      }
//      .onExitCommand {
//        if let onAction {
//          onAction(.exit)
//        } else {
//          viewFocus = nil
//        }
//      }
//      .onAppear {
//        if shouldFocusOnAppear {
//          DispatchQueue.main.async {
//            viewFocus = storeFocus
//          }
//        }
//      }
//    //      .task(id: focusElement) {
//    //        print("Focused element: \(focusElement.name). Focused @ \(Date.now.friendlyDateAndTime)")
//    //      }
//      .bind($storeFocus, to: $viewFocus)
//  }
//}
