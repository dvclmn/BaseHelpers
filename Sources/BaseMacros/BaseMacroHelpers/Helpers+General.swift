//
//  OtherHelpers.swift
//  BaseMacros
//
//  Created by Dave Coleman on 20/5/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension MacroHelpers {

  public static func retrieveStringArgument(from node: AttributeSyntax) -> String? {
    /// Check if there are any arguments.
    /// `LabeledExprListSyntax` refers to the list of parameters in a function signature.
    /// `StringLiteralExprSyntax` refers to parameters of type `String`.
    guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
      !arguments.isEmpty,
      let firstArgExpression = arguments.first?.expression,
      let stringExpression = firstArgExpression.as(StringLiteralExprSyntax.self)
    else {
      return nil
    }

    /// Extract the string value
    let segments: StringLiteralSegmentListSyntax = stringExpression.segments
    guard segments.count == 1, let segment = segments.first?.as(StringSegmentSyntax.self) else {
      return nil
    }
    return segment.content.text
  }

  public static func findTypeName(
    in structDecl: StructDeclSyntax,
    forProperty propertyType: VariableDeclSyntax
  ) -> IdentifierTypeSyntax? {

    if let binding = propertyType.bindings.first,
      let typeAnnotation = binding.typeAnnotation,
      let typeName = typeAnnotation.type.as(IdentifierTypeSyntax.self)
    {
      return typeName
    }
    return nil
  }

  public static func findExtensions(
    of structDecl: StructDeclSyntax,
    in context: some MacroExpansionContext
  ) -> [ExtensionDeclSyntax] {
    /// Get the parent node of the struct declaration
    guard let parent = structDecl.parent else {
      return []
    }

    /// Traverse the parent node to find extensions of the original struct
    var extensions: [ExtensionDeclSyntax] = []
    for child in parent.children(viewMode: .all) {
      if let ext = child.as(ExtensionDeclSyntax.self),
        ext.extendedType.as(IdentifierTypeSyntax.self)?.name.text == structDecl.name.text
      {
        extensions.append(ext)
      }
    }

    return extensions
  }

}

