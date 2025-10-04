//
//  NestedTypes.swift
//  BaseMacros
//
//  Created by Dave Coleman on 7/3/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension MacroHelpers {

  //  static func findNestedStructIncludingExtensions(
  //    structDecl: StructDeclSyntax,
  //    in node: AttributeSyntax,
  //    withTypeName typeName: IdentifierTypeSyntax,
  //    context: some MacroExpansionContext
  //  ) -> StructDeclSyntax? {
  //
  //    /// Look in the immediate members of the type.
  //    if let nested = findNestedStruct(in: structDecl, withTypeName: typeName) {
  //      return nested
  //    }
  //
  //    /// Look for an extension that extends this same type.
  ////    for member in node
  //
  //
  //
  ////    for member in node.arguments {
  ////      if let ext = member.item.as(ExtensionDeclSyntax.self),
  ////        ext.extendedType.description.trimmingCharacters(in: .whitespacesAndNewlines) == nominalDecl.identifier.text
  ////      {
  ////
  ////        // 4. Within the extension, look for the nested struct.
  ////        if let nestedExt = ext.memberBlock.members.compactMap({ $0.decl.as(StructDeclSyntax.self) })
  ////          .first(where: { $0.name.text == typeName.name.text })
  ////        {
  ////          return nestedExt
  ////        }
  ////      }
  ////    }
  ////    return nil
  //  }

  public static func findNestedStruct(
    in structDecl: StructDeclSyntax,
    withTypeName typeName: IdentifierTypeSyntax
  ) -> StructDeclSyntax? {

    let nestedStruct = findNestedStructs(in: structDecl) { nestedDecl in
      nestedDecl.name.text == typeName.name.text
    }
    .first

    if nestedStruct == nil {
      print("Couldn't find it")
    }

    return nestedStruct
  }

  private static func findNestedStructs(
    in structDecl: StructDeclSyntax,
    where predicate: (StructDeclSyntax) -> Bool
  ) -> [StructDeclSyntax] {

    return structDecl.memberBlock.members.compactMap { member in
      if let nestedDecl = member.decl.as(StructDeclSyntax.self), predicate(nestedDecl) {
        return nestedDecl
      }
      return nil
    }
  }

  /// This returns *all* structs found, no matching against anything.
  /// Helpful for debugging, seeing what (if anything) can be found.
  public static func listNestedStructs(
    in structDecl: StructDeclSyntax
  ) -> [StructDeclSyntax] {
    return findNestedStructs(in: structDecl) { _ in true }
  }


}

//static func findNestedStruct(
//  in structDecl: StructDeclSyntax,
//  withTypeName typeName: IdentifierTypeSyntax
//) -> StructDeclSyntax? {
//
//  guard
//    let nestedStruct = structDecl.memberBlock.members
//      .compactMap({ member in
//        if let nestedDecl = member.decl.as(StructDeclSyntax.self),
//           nestedDecl.name.text == typeName.name.text
//        {
//          return nestedDecl
//        }
//        return nil
//      })
//      .first
//  else {
//    print("Couldn't find it")
//    return nil
//  }
//
//  return nestedStruct
//
//}
//
//static func listNestedStructs(in structDecl: StructDeclSyntax) -> [StructDeclSyntax] {
//
//  let nestedStructs = structDecl.memberBlock.members
//    .compactMap({ member in
//      if let nestedDecl = member.decl.as(StructDeclSyntax.self) {
//        return nestedDecl
//      }
//      return nil
//    })
//
//  return nestedStructs
//
//}
//
