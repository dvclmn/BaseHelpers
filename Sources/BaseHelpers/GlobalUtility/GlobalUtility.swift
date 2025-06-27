//
//  GlobalUtility.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 14/6/2025.
//

import Foundation

@discardableResult
public func updateIfChanged<T: Equatable>(_ value: T, into target: inout T) -> Bool {
  guard target != value else { return false }
  target = value
  return true
}

public func updateOptionalIfChanged<T: Equatable>(_ value: T, into target: inout T?) -> Bool {
  guard target != value else { return false }
  target = value
  return true
}

@discardableResult
public func updateIfChanged<Root, Value: Equatable>(
  _ newValue: Value,
  on object: inout Root,
  keyPath: WritableKeyPath<Root, Value>
) -> Bool {
  guard object[keyPath: keyPath] != newValue else { return false }
  object[keyPath: keyPath] = newValue
  return true
}

@discardableResult
public func updateIfChangedWithOptionalRoot<Root, Value: Equatable>(
  _ newValue: Value,
  on object: inout Root?,
  keyPath: WritableKeyPath<Root, Value>
) -> Bool {
  guard object?[keyPath: keyPath] != newValue else { return false }
  object?[keyPath: keyPath] = newValue
  return true
}


/// ```
/// runIfChanged(newZoom, comparedTo: store.canvasState.zoom) {
///   print("Zoom changed, do something")
/// }
/// ```
@discardableResult
public func runIfChanged<T: Equatable>(
  _ newValue: T,
  comparedTo currentValue: T,
  perform action: () -> Void
) -> Bool {
  guard newValue != currentValue else { return false }
  action()
  return true
}
