//
//  Optional.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

import SwiftUI

public func ??<T: Sendable>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
  Binding(
    get: { lhs.wrappedValue ?? rhs },
    set: { lhs.wrappedValue = $0 }
  )
}


// MARK: - Optional bindings
/// By SwiftfulThinking
public extension Optional where Wrapped == String {
  var _boundString: String? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  var boundString: String {
    get {
      return _boundString ?? ""
    }
    set {
      _boundString = newValue.isEmpty ? nil : newValue
    }
  }
}

public extension Optional where Wrapped == Int {
  var _boundInt: Int? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  
  var boundInt: Int {
    get {
      return _boundInt ?? 0
    }
    set {
      _boundInt = (newValue == 0) ? nil : newValue
    }
  }
}
public extension Optional where Wrapped == Bool {
  var _boundBool: Bool? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  
  var boundBool: Bool {
    get {
      return _boundBool ?? false
    }
    set {
      _boundBool = (newValue == false) ? nil : newValue
    }
  }
}

//func ??<Bool>(lhs: Binding<Optional<Bool>>, rhs: Bool) -> Binding<Bool> {
//    Binding(
//        get: { lhs.wrappedValue ?? rhs },
//        set: { lhs.wrappedValue = $0 }
//    )
//}
