//
//  SyntaxExtensions.swift
//  BaseMacros
//
//  Created by Dave Coleman on 19/9/2025.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// Below from https://github.com/swiftlang/swift-syntax/
// swift-syntax/Examples/Sources/MacroExamples/Implementation/Member/NewTypeMacro.swift

extension DeclModifierSyntax {
  public var isPublicAccessLevel: Bool {
    switch self.name.tokenKind {
      case .keyword(.public): return true
      default: return false
    }
  }
}

extension SyntaxStringInterpolation {
  public mutating func appendInterpolation<Node: SyntaxProtocol>(_ node: Node?) {
    if let node {
      appendInterpolation(node)
    }
  }
}

extension LabeledExprListSyntax {
  /// Retrieve the first element with the given label.
  public func first(labeled name: String) -> Element? {
    return first { element in
      if let label = element.label, label.text == name {
        return true
      }

      return false
    }
  }
}

extension TokenSyntax {
  public var initialUppercased: String {
    let name = self.text
    guard let initial = name.first else {
      return name
    }

    return "\(initial.uppercased())\(name.dropFirst())"
  }
}

extension DeclGroupSyntax {
  public func descriptiveDeclKind(withArticle article: Bool = false) -> String {
    switch self {
      case is ActorDeclSyntax:
        return article ? "an actor" : "actor"
      case is ClassDeclSyntax:
        return article ? "a class" : "class"
      case is ExtensionDeclSyntax:
        return article ? "an extension" : "extension"
      case is ProtocolDeclSyntax:
        return article ? "a protocol" : "protocol"
      case is StructDeclSyntax:
        return article ? "a struct" : "struct"
      case is EnumDeclSyntax:
        return article ? "an enum" : "enum"
      default:
        fatalError("Unknown DeclGroupSyntax")
    }
  }
}

extension EnumDeclSyntax {
  public var caseElements: [EnumCaseElementSyntax] {
    memberBlock.members.flatMap { member in
      guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else {
        return [EnumCaseElementSyntax]()
      }

      return Array(caseDecl.elements)
    }
  }
}
