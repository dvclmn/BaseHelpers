//
//  CaseDetection.swift
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

import SwiftSyntax
import SwiftSyntaxMacros

public enum CaseDetectionMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf decl: some DeclGroupSyntax,
    conformingTo: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    /// Dig out the access control keyword we need.
    let access = decl.modifiers.first(where: \.isPublicAccessLevel)
    let members = decl.memberBlock.members
    
    return members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .map { $0.elements.first!.name }
      .map { ($0, $0.initialUppercased) }
      .map { original, uppercased in
        """
        \(access)var is\(raw: uppercased): Bool {
          if case .\(raw: original) = self {
            return true
          }

          return false
        }
        """
      }
  }
}

