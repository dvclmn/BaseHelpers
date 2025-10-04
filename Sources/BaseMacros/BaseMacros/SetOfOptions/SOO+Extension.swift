//
//  SOO+Extension.swift
//  BaseMacros
//
//  Created by Dave Coleman on 18/9/2025.
//

import BasePrimitives
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension SetOfOptionsMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    /// Decode the expansion arguments.
    guard
      let (structDecl, _, _) = decodeExpansion(
        of: node,
        attachedTo: declaration,
        in: context,
        emitDiagnostics: false
      )
    else { return [] }

    /// Check for existing conformances
    var hasOptionSet = false
    var hasSendable = false

    if let inheritedTypes = structDecl.inheritanceClause?.inheritedTypes {
      for inherited in inheritedTypes {
        let typeName = inherited.type.trimmedDescription
        if typeName == "OptionSet" {
          hasOptionSet = true
        } else if typeName == "Sendable" {
          hasSendable = true
        }
      }
    }

    /// Build conformance list based on what's missing
    var conformances: [String] = []
    if !hasOptionSet {
      conformances.append("OptionSet")
    }
    if !hasSendable {
      conformances.append("Sendable")
    }

    /// If all conformances are already present, don't add an extension
    guard !conformances.isEmpty else {
      return []
    }

    /// Create extension with only the missing conformances
    let conformanceList = conformances.joined(separator: ", ")
    return [try ExtensionDeclSyntax("extension \(type): \(raw: conformanceList) {}")]
  }
}

