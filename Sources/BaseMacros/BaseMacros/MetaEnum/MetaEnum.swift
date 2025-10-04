//
//  MetaEnum.swift
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

public struct MetaEnumMacro {
  let parentTypeName: TokenSyntax
  let childCases: [EnumCaseElementSyntax]
  let access: DeclModifierListSyntax.Element?
  let parentParamName: TokenSyntax
  
  init(node: AttributeSyntax, declaration: some DeclGroupSyntax, context: some MacroExpansionContext) throws {
    guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
      throw DiagnosticsError(diagnostics: [
        CaseMacroDiagnostic.notAnEnum(declaration).diagnose(at: Syntax(node))
      ])
    }
    
    parentTypeName = enumDecl.name.with(\.trailingTrivia, [])

    access = enumDecl.modifiers.first(where: \.isPublicAccessLevel)
    
    childCases = enumDecl.caseElements.map { parentCase in
      parentCase.with(\.parameterClause, nil)
    }
    
    parentParamName = context.makeUniqueName("parent")
  }
  
  func makeMetaEnum() -> DeclSyntax {
    // FIXME: Why does this need to be a string to make trailing trivia work properly?
    let caseDecls =
    childCases
      .map { childCase in
        "  case \(childCase.name)"
      }
      .joined(separator: "\n")
    
    return """
      \(access)enum Meta {
      \(raw: caseDecls)
      \(makeMetaInit())
      }
      """
  }
  
  func makeMetaInit() -> DeclSyntax {
    // FIXME: Why does this need to be a string to make trailing trivia work properly?
    let caseStatements =
    childCases
      .map { childCase in
        """
          case .\(childCase.name):
            self = .\(childCase.name)
        """
      }
      .joined(separator: "\n")
    
    return """
      \(access)init(_ \(parentParamName): \(parentTypeName)) {
        switch \(parentParamName) {
      \(raw: caseStatements)
        }
      }
      """
  }
}

extension MetaEnumMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let macro = try MetaEnumMacro(node: node, declaration: declaration, context: context)
    
    return [macro.makeMetaEnum()]
  }
}

enum CaseMacroDiagnostic {
  case notAnEnum(DeclGroupSyntax)
}
extension CaseMacroDiagnostic: DiagnosticMessage {
  var message: String {
    switch self {
      case .notAnEnum(let decl):
        return "'@MetaEnum' can only be attached to an enum, not \(decl.descriptiveDeclKind(withArticle: true))"
    }
  }
  
  var diagnosticID: MessageID {
    switch self {
      case .notAnEnum:
        return MessageID(domain: "MetaEnumDiagnostic", id: "notAnEnum")
    }
  }
  
  var severity: DiagnosticSeverity {
    switch self {
      case .notAnEnum:
        return .error
    }
  }
  
  func diagnose(at node: Syntax) -> Diagnostic {
    Diagnostic(node: node, message: self)
  }
}
