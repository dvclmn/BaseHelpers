//
//  MemberwiseInit.swift
//  BaseMacros
//
//  Created by Dave Coleman on 27/2/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
//import BaseMacroHelpers

extension PersistableMacro {
  static func generateMemberwiseInitializer(properties: [ExtractableProperty]) throws -> DeclSyntax {
    /// If no properties, return an empty initializer
    if properties.isEmpty {
      return DeclSyntax(stringLiteral: "public init() {}")
    }
    
    /// Build parameter list with proper types and default values
    let parameterList = properties.map { property -> String in
      let paramType = property.isOptional ? "\(property.type)?" : property.type
      let defaultValue = property.defaultValue != nil ? " = \(property.defaultValue!)" :
      property.isOptional ? " = nil" : ""
      return "\(property.name): \(paramType)\(defaultValue)"
    }.joined(separator: ",\n")
    
    /// Build assignment statements with proper indentation
    let assignmentList = properties.map { property in
      return "self.\(property.name) = \(property.name)"
    }.joined(separator: "\n")
    
    let initializer = """
    public init(
      \(parameterList)
    ) {
      \(assignmentList)
    }
    """
    
    return DeclSyntax(stringLiteral: initializer)
  }
}

// From MemberwiseInit: https://github.com/gohanlon/swift-memberwise-init-macro
//extension VariableDeclSyntax {
//  func modifiersExclude(_ keywords: [Keyword]) -> Bool {
//    return !self.modifiers.containsAny(of: keywords.map { TokenSyntax.keyword($0) })
//  }
//  
//  func firstModifierWhere(keyword: Keyword) -> DeclModifierSyntax? {
//    let keywordText = TokenSyntax.keyword(keyword).text
//    return self.modifiers.first { modifier in
//      modifier.name.text == keywordText
//    }
//  }
//}
