//
//  SOO+AddMethods.swift
//  BaseMacros
//
//  Created by Dave Coleman on 18/9/2025.
//

import SharedHelpers
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension SetOfOptionsMacro: MemberMacro {
  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf decl: some DeclGroupSyntax,
    conformingTo: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    /// Decode the expansion arguments.
    guard
      let (_, optionsEnum, rawType) = decodeExpansion(
        of: attribute,
        attachedTo: decl,
        in: context,
        emitDiagnostics: true
      )
    else { return [] }

    /// Find all of the case elements.
    let caseElements: [EnumCaseElementSyntax] = optionsEnum.memberBlock.members.flatMap { member in
      guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else {
        return [EnumCaseElementSyntax]()
      }
      return Array(caseDecl.elements)
    }

    /// Dig out the access control keyword we need.
    let access = decl.modifiers.first(where: \.isPublicAccessLevel)

    // MARK: - Create Option Set static properties
    let staticVars = caseElements.map { (element) -> DeclSyntax in
      """
        \(access)static let \(element.name): Self = Self(rawValue: 1 << \(optionsEnum.name).\(element.name).rawValue)
      """
    }

    // MARK: - Create String Raw values
    //    let stringSwitchCases = caseElements.map { enumCase in
    //      let snake = enumCase.name.text.camelToSnake
    //      return "case .\(enumCase.name): return \"\(snake)\""
    //    }.joined(separator: "\n    ")
    let snakeConditional: String = "isSnakeCase"

    let stringSwitchCases = caseElements.map { enumCase in
      let camel = enumCase.name.text
      let snake = camel.camelToSnake

      return "  case .\(enumCase.name): \(snakeConditional) ? \"\(snake)\" : \"\(camel)\""
    }.joined(separator: "\n  ")

    let optionSetStringBuilder: String = caseElements.map { el in
      """
        if self.contains(.\(el.name)) {
          strings.append(Self.stringValue(for: \(optionsEnum.name).\(el.name), \(snakeConditional): \(snakeConditional)))
        }
        """
    }.joined(separator: "\n  ")

    let extraDecls: [DeclSyntax] = [
      """
      \(access)static func stringValue(
        for option: \(optionsEnum.name), 
        \(raw: snakeConditional): Bool = false
      ) -> String {
        switch option {
            \(raw: stringSwitchCases)
        } 
      }
      """,

      """
      \(access)func stringValueJoined(isSnakeCase: Bool = false) -> String {
        var strings: [String] = []
        \(raw: optionSetStringBuilder)
        return strings.joined(separator: ", ")
      }
      """,
    ]

    return [
      "\(access)typealias RawValue = \(rawType)",
      "\(access)var rawValue: RawValue",
      "\(access)init() { self.rawValue = 0 }",
      "\(access)init(rawValue: RawValue) { self.rawValue = rawValue }",
    ] + staticVars + extraDecls
  }
}
