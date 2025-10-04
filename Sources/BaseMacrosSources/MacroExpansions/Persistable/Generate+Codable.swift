//
//  Generate+Codable.swift
//  Persistable
//
//  Created by Dave Coleman on 21/2/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
//import BaseMacroHelpers

struct CodableMethods {

  static func generateCodableMethods(
    structName: String,
    properties: [ExtractableProperty]
  ) -> [DeclSyntax] {

    /// Build CodingKeys cases: if there is a custom key, use that on the right-hand side.
    var codingKeyCases = [String]()
    for property in properties {

      /// If we have an `@Attribute` on this property, let's make sure we adjust the
      /// CodingKeys enum accordingly
      if let customKey = property.customKey {
        let caseString = """
            case \(property.name)
            case \(customKey)
          """
        codingKeyCases.append(caseString)
      } else {
        codingKeyCases.append("case \(property.name)")
      }
    }

    let codingKeysEnum = """
      nonisolated private enum CodingKeys: String, CodingKey {
        \(codingKeyCases.joined(separator: "\n"))
      }
      """

    /// ```
    /// if container.contains(.gamesOwnedCount) {
    ///   self.gamesOwnedCount = try container.decode(Int.self, forKey: .gamesOwnedCount)
    /// } else {
    ///   self.gamesOwnedCount = try container.decode(Int.self, forKey: .gamesOwned)
    /// }
    /// ```

    /// Create the decode method, using `decodeIfPresent` for optional properties.
    var decodeLines = [String]()
    for property in properties {
      if let customKey = property.customKey {
        /// Use decodeIfPresent for optionals, decode for non-optionals.
        let decodeMethodString = property.isOptional ? "decodeIfPresent" : "decode"
        /// Generate fallback logic when legacy key is provided.
        let decodeString = """
            if container.contains(.\(property.name)) {
                self.\(property.name) = try container.\(decodeMethodString)(\(property.type).self, forKey: .\(property.name))
            } else {
                self.\(property.name) = try container.\(decodeMethodString)(\(property.type).self, forKey: .\(customKey))
            }
          """
        decodeLines.append(decodeString)
      } else {
        /// For properties without custom key, simply pick the appropriate decoding method.
        let decodeMethodString = property.isOptional ? "decodeIfPresent" : "decode"
        let decodeString = """
            self.\(property.name) = try container.\(decodeMethodString)(\(property.type).self, forKey: .\(property.name))
          """
        decodeLines.append(decodeString)
      }
    }

    let decoderInit = """
      public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        \(decodeLines.joined(separator: "\n"))
      }
      """

    /// Similarly, generate encode calls using the custom key (if available).
    var encodeLines = [String]()
    for property in properties {
//      let keyName = property.customKey ?? property.name
      encodeLines.append("try container.encode(\(property.name), forKey: .\(property.name))")
    }

    let encodeMethod = """
      public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        \(encodeLines.joined(separator: "\n"))
      }
      """

    return [
      DeclSyntax(stringLiteral: codingKeysEnum),
      DeclSyntax(stringLiteral: decoderInit),
      DeclSyntax(stringLiteral: encodeMethod),
    ]
  }

}
