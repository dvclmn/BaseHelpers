//
//  Store.swift
//  Collection
//
//  Created by Dave Coleman on 24/10/2024.
//


import ComposableArchitecture
import SwiftUI

public struct StoreTypeID<State, Action>: Hashable {
  public static func == (lhs: StoreTypeID<State, Action>, rhs: StoreTypeID<State, Action>) -> Bool {
    true // Same types will always be equal
  }
  
  public init() {}
  
  public func hash(into hasher: inout Hasher) {
    // Hash the type names for consistency
    hasher.combine(String(describing: State.self))
    hasher.combine(String(describing: Action.self))
  }
}

public protocol AnyReducerProtocol: Reducer where State: ObservableState {
//  associatedtype Body = ReducerOf<Self>
  
//  var body: Body { get }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action>
}

// Make Reducer conform to our protocol
extension Reducer where Self: AnyReducerProtocol {
  public var body: some ReducerOf<Self> {
    self
  }
}

// Type-erasing wrapper for reducers
@dynamicMemberLookup
public struct AnyReducer<State, Action>: Reducer {
  let _reduce: (inout State, Action) -> Effect<Action>
  
  public init<R: Reducer>(_ reducer: R) where R.State == State, R.Action == Action {
    self._reduce = reducer.reduce
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    _reduce(&state, action)
  }
  
  // Allow access to the wrapped reducer's properties
  public subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> (State) -> T {
    { state in state[keyPath: keyPath] }
  }
}


public struct StoreKey<State, Action>: EnvironmentKey {
  public static var defaultValue: StoreOf<AnyReducer<State, Action>>? { nil }
}


public extension EnvironmentValues {
  subscript<State, Action>(storeID: StoreTypeID<State, Action>) -> StoreOf<AnyReducer<State, Action>>? {
    get { self[StoreKey<State, Action>.self] }
    set { self[StoreKey<State, Action>.self] = newValue }
  }
}

@propertyWrapper
public struct StoreEnvironment<R: Reducer> {
  @Environment private var store: StoreOf<AnyReducer<R.State, R.Action>>?
  
  public init() {
    self._store = Environment(\.[StoreTypeID<R.State, R.Action>()])
  }
  
  public var wrappedValue: StoreOf<R> {
    guard let store = store else {
      fatalError("Store for reducer of type \(R.self) not found in environment")
    }
    return store
  }
}

public struct StoreModifier<R: Reducer>: ViewModifier {
  public let store: StoreOf<R>
  
  public func body(content: Content) -> some View {
    content.environment(
      \.[StoreTypeID<R.State, R.Action>()],
       store
    )
  }
}

public extension View {
  func withStore<R: Reducer>(_ store: StoreOf<R>) -> some View {
    modifier(StoreModifier<R>(store: store))
  }
}

//struct StoreReducer: Reducer {
//  typealias State = State
//  typealias Action = Action
//  
//  let store: Store<State, Action>
//  
//  func reduce(into state: inout State, action: Action) -> Effect<Action> {
//    store.send(action)
//    return .none
//  }
//}

// Create our reducer instance
//let reducer = StoreReducer(store: store)
//return modifier(StoreModifier<StoreReducer>(store: store))

//public extension View {
//  func withStore<R: Reducer>(_ store: StoreOf<R>) -> some View {
//    modifier(StoreModifier<R>(store: store))
//  }
//  
////   Overload specifically for handling type inference with static properties
////   Overload for working with Store instances directly
//  func withStore<State, Action>(_ store: Store<State, Action>) -> some View {
//    // Create a concrete Reducer type that wraps our store
//    
//  }

//}



//
//
//// First, let's create a type-erasing protocol that any TCA Store can conform to
//@MainActor
//public protocol AnyStoreProtocol: Observable {
//  var anyState: Any { get }
//  func send(_ action: Any)
//  func scope<T>(_ transform: @escaping (Any) -> T?) -> T?
//  func withState<T>(_ work: (Any) -> T) -> T
//}
//
//@MainActor
//extension Store: AnyStoreProtocol where State: ObservableState {
//  nonisolated public var anyState: Any {
//    // Use _read to access state synchronously
//    _read { yield state }
//  }
//
//  public func send(_ action: Any) {
//    guard let typedAction = action as? Action else {
//      assertionFailure("Invalid action type sent to store")
//      return
//    }
//    self.send(typedAction)
//  }
//  
//  public func scope<T>(_ transform: @escaping (Any) -> T?) -> T? {
//    transform(self.state)
//  }
//  
//  public func withState<T>(_ work: (Any) -> T) -> T {
//    work(self.state)
//  }
//
//}

//@MainActor
//public struct StoreKey: EnvironmentKey {
//  public static let defaultValue: AnyStoreProtocol? = nil
//}

//
//public extension EnvironmentValues {
//  var anyStore: AnyStoreProtocol? {
//    get { self[StoreKey.self] }
//    set { self[StoreKey.self] = newValue }
//  }
//}

// Create a property wrapper to easily access typed stores from the environment
//@propertyWrapper
//public struct StoreEnvironment<R: Reducer> {
//  @Environment(\.anyStore) private var anyStore
//  
//  public var wrappedValue: StoreOf<R> {
////    guard let store = anyStore as? StoreOf<R> else {
////      fatalError("Store of type \(R.self) not found in environment")
////    }
//    return StoreOf<R>
//  }
//  
//  public init() {}
//}

//// View modifier to inject stores into the environment
//public struct StoreModifier<R: Reducer>: ViewModifier where R.State: ObservableState {
//  let store: StoreOf<R>
//  
//  public func body(content: Content) -> some View {
//    content.environment(\.anyStore, store)
//  }
//}
//
//// Convenient View extension
//public extension View {
//  func withStore<R: Reducer>(_ store: StoreOf<R>) -> some View where R.State: ObservableState {
//    modifier(StoreModifier<R>(store: store))
//  }
//}

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
