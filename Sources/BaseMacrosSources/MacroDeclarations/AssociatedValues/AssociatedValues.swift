//
//  AssociatedValues.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

// Full credit to Andrea Bernardini for this
// AssociatedValues macro. See repo:
// https://github.com/bernndr/swift-macros/
@attached(member, names: arbitrary)
public macro AssociatedValues() = #externalMacro(
  module: "BaseMacros",
  type: "AssociatedValuesMacro"
)
