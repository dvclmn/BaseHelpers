//
//  MetaEnum.swift
//  BaseMacros
//
//  Created by Dave Coleman on 18/9/2025.
//

@attached(member, names: named(Meta))
public macro MetaEnum() = #externalMacro(
  module: "BaseMacros",
  type: "MetaEnumMacro"
)
