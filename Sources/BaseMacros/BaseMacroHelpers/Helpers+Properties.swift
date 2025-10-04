//
//  CommonMethods.swift
//  BaseMacros
//
//  Created by Dave Coleman on 7/3/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum MacroHelpers {

  public static func findProperty(
    in structDecl: StructDeclSyntax,
    withName propertyName: String
  ) -> VariableDeclSyntax? {

    for member in structDecl.memberBlock.members {

      if let variable: VariableDeclSyntax = member.decl.as(VariableDeclSyntax.self),

        /// A variable declaration can contain multiple pattern bindings, because it’s possible
        /// to define multiple variables after a single `let` keyword, for example
        ///
        /// ```swift
        /// let x: Int = 1, y: Int = 2
        /// ```
        let binding: PatternBindingListSyntax.Element = variable.bindings.first,
        let identifier: IdentifierPatternSyntax = binding.pattern.as(IdentifierPatternSyntax.self),
        identifier.identifier.text == propertyName
      {
        return variable
      }
    }
    return nil
  }

  public static func propertyNameAsString(_ property: VariableDeclSyntax) -> String {
    guard let binding = property.bindings.first,
      let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
    else {
      print("This simply won't work, so hopefully we never get here")
      return property.description
    }
    return identifier.identifier.text

  }

  public static func listProperties(
    in structDecl: StructDeclSyntax
  ) -> [ConfigAttributes] {

    var properties: [ConfigAttributes] = []

    for member in structDecl.memberBlock.members {
      if let variable = member.decl.as(VariableDeclSyntax.self),
        //         variable.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) }) == false,
        let binding: PatternBindingListSyntax.Element = variable.bindings.first,
        //        let identifier: IdentifierPatternSyntax = binding.pattern.as(IdentifierPatternSyntax.self),
        let typeAnnotation: TypeAnnotationSyntax = binding.typeAnnotation,
        let typeName: IdentifierTypeSyntax = typeAnnotation.type.as(IdentifierTypeSyntax.self)
      {
        properties.append(
          ConfigAttributes(
            propertyName: variable,
            typeName: typeName
          ))
      }
    }  // END loop over members

    return properties

  }
  
  
  /// Extract properties from struct
  public static func extractProperties(from structDecl: StructDeclSyntax) -> [ExtractableProperty] {
    structDecl.memberBlock.members.compactMap { member -> ExtractableProperty? in
      guard let variable = member.decl.as(VariableDeclSyntax.self),
            let binding = variable.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
            let typeNode = binding.typeAnnotation?.type
      else {
        return nil
      }
      
      /// Skip computed properties
      if binding.accessorBlock != nil { return nil }
      
      /// Skip static or class properties
      if variable.modifiers.contains(where: {
        $0.name.tokenKind == .keyword(.static) || $0.name.tokenKind == .keyword(.class)
      }) {
        return nil
      }
      
      /// Extract type information
      let isOptional: Bool
      let underlyingType: String
      if let optionalType = typeNode.as(OptionalTypeSyntax.self) {
        isOptional = true
        underlyingType = optionalType.wrappedType.description.trimmingCharacters(in: .whitespacesAndNewlines)
      } else {
        isOptional = false
        underlyingType = typeNode.description.trimmingCharacters(in: .whitespacesAndNewlines)
      }
      
      /// Extract attribute information
      let customKey = extractCustomKey(from: variable)
      
      /// Extract default value if present
      let defaultValue = binding.initializer?.value.description
      
      return ExtractableProperty(
        name: identifier.identifier.text,
        type: underlyingType,
        isOptional: isOptional,
        customKey: customKey,
        defaultValue: defaultValue
      )
    }
  }
  
  private static func extractTypeInfo(from typeNode: TypeSyntax) -> (isOptional: Bool, type: String) {
    guard let optionalType = typeNode.as(OptionalTypeSyntax.self) else {
      return (false, typeNode.description.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    return (true, optionalType.wrappedType.description.trimmingCharacters(in: .whitespacesAndNewlines))
  }
  
  private static func extractCustomKey(from variable: VariableDeclSyntax) -> String? {
    for attribute in variable.attributes {
      if let attrSyntax = attribute.as(AttributeSyntax.self),
         let attrName = attrSyntax.attributeName.as(IdentifierTypeSyntax.self),
         attrName.description == "Attribute",
         let argList = attrSyntax.arguments?.as(LabeledExprListSyntax.self),
         let labeledArg = argList.first(where: { $0.label?.text == "originalName" }),
         let stringLiteral = labeledArg.expression.as(StringLiteralExprSyntax.self)
      {
        
        let literalValue = stringLiteral.segments
          .compactMap { segment -> String? in
            if let segment = segment.as(StringSegmentSyntax.self) {
              return segment.content.text
            }
            return nil
          }
          .joined()
        
        return literalValue
      }
    }
    return nil
  }
}
