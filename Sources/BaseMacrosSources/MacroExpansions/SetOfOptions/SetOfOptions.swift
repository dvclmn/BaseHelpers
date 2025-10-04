//
//  SetOfOptions.swift
//  BaseMacros
//
//  Created by Dave Coleman on 18/9/2025.
//

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SetOfOptionsMacro {
  /// Decodes the arguments to the macro expansion.
  ///
  /// - Returns: the important arguments used by the various roles of this
  /// macro inhabits, or nil if an error occurred.
  static func decodeExpansion(
    of attribute: AttributeSyntax,
    attachedTo decl: some DeclGroupSyntax,
    in context: some MacroExpansionContext,
    emitDiagnostics: Bool
  ) -> (StructDeclSyntax, EnumDeclSyntax, TypeSyntax)? {

    /// Determine the name of the options enum.
    let optionsEnumName: String
    if case .argumentList(let arguments) = attribute.arguments,
      let optionEnumNameArg = arguments.first(labeled: optionsEnumNameArgumentLabel)
    {
      /// We have a options name; make sure it is a string literal.
      guard let stringLiteral = optionEnumNameArg.expression.as(StringLiteralExprSyntax.self),
        stringLiteral.segments.count == 1,
        case .stringSegment(let optionsEnumNameString)? = stringLiteral.segments.first
      else {
        if emitDiagnostics {
          context.diagnose(
            SetOfOptionsMacroDiagnostic.requiresStringLiteral(optionsEnumNameArgumentLabel).diagnose(
              at: optionEnumNameArg.expression
            )
          )
        }
        return nil
      }

      optionsEnumName = optionsEnumNameString.content.text
    } else {
      optionsEnumName = defaultOptionsEnumName
    }

    /// Only apply to structs.
    guard let structDecl = decl.as(StructDeclSyntax.self) else {
      if emitDiagnostics {
        context.diagnose(SetOfOptionsMacroDiagnostic.requiresStruct.diagnose(at: decl))
      }
      return nil
    }

    /// Find the option enum within the struct.
    let members = decl.memberBlock.members.compactMap({ member in
      if let enumDecl = member.decl.as(EnumDeclSyntax.self),
        enumDecl.name.text == optionsEnumName
      {
        return enumDecl
      }
      return nil
    })

    guard let optionsEnum = members.first
    else {
      if emitDiagnostics {
        let diagnostic = SetOfOptionsMacroDiagnostic.requiresOptionsEnum(optionsEnumName)
        context.diagnose(diagnostic.diagnose(at: decl))
      }
      return nil
    }

    /// Retrieve the raw type from the attribute.
    guard let genericArgs = attribute.attributeName.as(IdentifierTypeSyntax.self)?.genericArgumentClause,
      let rawType = genericArgs.arguments.first?.argument
    else {
      if emitDiagnostics {
        context.diagnose(SetOfOptionsMacroDiagnostic.requiresOptionsEnumRawType.diagnose(at: attribute))
      }
      return nil
    }

    return (structDecl, optionsEnum, rawType)
  }
}
