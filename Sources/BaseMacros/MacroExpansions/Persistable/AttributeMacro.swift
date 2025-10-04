//
//  AttributeMacro.swift
//  PersistableMacro
//
//  Created by Dave Coleman on 21/2/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AttributeMacro: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    /// Does nothing, used only to decorate members with data
    return []
  }
}
