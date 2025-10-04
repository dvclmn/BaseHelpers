//
//  Plugin.swift
//  Persistable
//
//  Created by Dave Coleman on 14/2/2025.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct BaseMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    PersistableMacro.self,
    AttributeMacro.self,
    CaseDetectionMacro.self,
    MetaEnumMacro.self,
    SetOfOptionsMacro.self,
  ]
}

