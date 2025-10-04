//
//  StylerMacro.swift
//  Persistable
//
//  Created by Dave Coleman on 13/11/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
//import BaseMacroHelpers

public struct PersistableMacro: MemberMacro, ExtensionMacro {

  // MARK: - Adding methods
  /// Support for adding methods directly to the struct
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw CustomError.notAStruct
    }

    let structName = structDecl.name.text

    /// Get all stored properties from the struct
    let properties = MacroHelpers.extractProperties(from: structDecl)

    /// Generate coding keys enum and codable methods
    var declarations = CodableMethods.generateCodableMethods(
      structName: structName,
      properties: properties
    )
    
    /// Add a synthesized memberwise initializer
    declarations.append(try generateMemberwiseInitializer(properties: properties))
    
    return declarations
  }

  // MARK: - RawRep expansion
  /// Support for adding extensions to the struct (for RawRepresentable)
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw CustomError.notAStruct
    }

    let structName = structDecl.name.text

    let rawRep = try GenerateRawRep.generateRawRepresentableExtension(structName: structName)
    
    /// Generate RawRepresentable extension
    return [rawRep]
  }

}



enum CustomError: Error, CustomStringConvertible {
  
  case notAStruct

  var description: String {
    switch self {
      case .notAStruct:
        return "This macro can only be applied to a struct."
    }
  }
}
