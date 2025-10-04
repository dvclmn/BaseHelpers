//
//  Helpers+Models.swift
//  BaseMacros
//
//  Created by Dave Coleman on 20/5/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder

public struct ConfigAttributes {
  public let propertyName: VariableDeclSyntax
  public let typeName: IdentifierTypeSyntax
  
  public init(
    propertyName: VariableDeclSyntax,
    typeName: IdentifierTypeSyntax
  ) {
    self.propertyName = propertyName
    self.typeName = typeName
  }
  
  public var propertyString: String {
    MacroHelpers.propertyNameAsString(propertyName)
  }
  public var typeString: String {
    typeName.name.text
  }
}
