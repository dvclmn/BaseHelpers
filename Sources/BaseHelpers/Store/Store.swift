//
//  Store.swift
//  Collection
//
//  Created by Dave Coleman on 24/10/2024.
//


import ComposableArchitecture
import SwiftUI

// First, let's create a type-erasing protocol that any TCA Store can conform to
@MainActor
public protocol AnyStoreProtocol: Observable {
  var anyState: Any { get }
  func send(_ action: Any)
  func scope<T>(_ transform: @escaping (Any) -> T?) -> T?
  func withState<T>(_ work: (Any) -> T) -> T
}

@MainActor
extension Store: AnyStoreProtocol where State: ObservableState {
  nonisolated public var anyState: Any {
    // Use _read to access state synchronously
    _read { yield state }
  }

  public func send(_ action: Any) {
    guard let typedAction = action as? Action else {
      assertionFailure("Invalid action type sent to store")
      return
    }
    self.send(typedAction)
  }
  
  public func scope<T>(_ transform: @escaping (Any) -> T?) -> T? {
    transform(self.state)
  }
  
  public func withState<T>(_ work: (Any) -> T) -> T {
    work(self.state)
  }

}

@MainActor
public struct StoreKey: EnvironmentKey {
  public static let defaultValue: AnyStoreProtocol? = nil
}

// Extend EnvironmentValues to access our store
public extension EnvironmentValues {
  var anyStore: AnyStoreProtocol? {
    get { self[StoreKey.self] }
    set { self[StoreKey.self] = newValue }
  }
}

// Create a property wrapper to easily access typed stores from the environment
@propertyWrapper
public struct StoreEnvironment<R: Reducer> {
  @Environment(\.anyStore) private var anyStore
  
  public var wrappedValue: StoreOf<R> {
//    guard let store = anyStore as? StoreOf<R> else {
//      fatalError("Store of type \(R.self) not found in environment")
//    }
    return StoreOf<R>
  }
  
  public init() {}
}

// View modifier to inject stores into the environment
public struct StoreModifier<R: Reducer>: ViewModifier {
  let store: StoreOf<R>
  
  public func body(content: Content) -> some View {
    content.environment(\.anyStore, store)
  }
}

// Convenient View extension
public extension View {
  func withStore<R: Reducer>(_ store: StoreOf<R>) -> some View {
    modifier(StoreModifier<R>(store: store))
  }
}

//struct StoreKey: EnvironmentKey {
//  @MainActor
//  static let defaultValue = Store(initialState: AppHandler.State()) {
//    AppHandler()
//  }
//}
//
//extension EnvironmentValues {
//  var store: StoreOf<AppHandler> {
//    get { self[StoreKey.self] }
//    set { self[StoreKey.self] = newValue }
//  }
//}
//struct StoreModifier<R: Reducer>: ViewModifier {
//  
//  let store: StoreOf<R>
//  
//  func body(content: Content) -> some View {
//    content
//      .environment(\.store, store)
//  }
//}
//extension View {
//  func withStore<R: Reducer>(_ store: StoreOf<R>) -> some View {
//    self.modifier(StoreModifier<R>(store: store))
//  }
//}
//
