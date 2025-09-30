//
//  Togglable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/9/2025.
//

public protocol CaseTogglable: CaseIterable, CaseCyclable {
  mutating func toggle()
}

extension CaseTogglable {
  public mutating func toggle() {
    precondition(Self.allCases.count == 2, "CaseTogglable/toggle() requires exactly two cases")
    self = toNext()
  }
}
