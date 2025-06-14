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
