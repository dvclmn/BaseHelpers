//
//  File.swift
//  
//
//  Created by Dave Coleman on 3/8/2024.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroCollectionPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UnwrapURLMacro.self
    ]
}

