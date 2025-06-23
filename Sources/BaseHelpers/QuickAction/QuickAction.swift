//
//  QuickAction.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/6/2025.
//

public struct QuickAction: Sendable {
  let title: String
  let action: @Sendable () -> Void
  
  public init(_ title: String, action: @Sendable @escaping () -> Void) {
    self.title = title
    self.action = action
  }
}
