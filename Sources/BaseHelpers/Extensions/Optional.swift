//
//  Optional.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

import SwiftUI

public func ?? <T: Sendable>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
  Binding(
    get: { lhs.wrappedValue ?? rhs },
    set: { lhs.wrappedValue = $0 }
  )
}

extension Optional where Wrapped: DisplayPair {
  public var displayIfAvailable: String {
    return self?.displayString ?? "nil"
  }
}

// MARK: - Optional bindings
/// By SwiftfulThinking
extension Optional where Wrapped == String {
  public var _boundString: String? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  public var boundString: String {
    get {
      return _boundString ?? ""
    }
    set {
      _boundString = newValue.isEmpty ? nil : newValue
    }
  }
}

extension Optional where Wrapped == Int {
  public var _boundInt: Int? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }

  public var boundInt: Int {
    get {
      return _boundInt ?? 0
    }
    set {
      _boundInt = (newValue == 0) ? nil : newValue
    }
  }
}
extension Optional where Wrapped == Bool {
  public var _boundBool: Bool? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }

  public var boundBool: Bool {
    get {
      return _boundBool ?? false
    }
    set {
      _boundBool = (newValue == false) ? nil : newValue
    }
  }
}

extension Optional where Wrapped == CGSize {
  public var _boundSize: CGSize? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }

  public var boundSize: CGSize {
    //  func boundSize(_ fallback: CGSize = .zero) -> CGSize {
    get {
      return _boundSize ?? .zero
    }
    set {
      _boundSize = (newValue == .zero) ? nil : newValue
    }
  }
}

//func ??<Bool>(lhs: Binding<Optional<Bool>>, rhs: Bool) -> Binding<Bool> {
//    Binding(
//        get: { lhs.wrappedValue ?? rhs },
//        set: { lhs.wrappedValue = $0 }
//    )
//}
