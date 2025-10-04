//
//  Generate+RawRep.swift
//  Persistable
//
//  Created by Dave Coleman on 21/2/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct GenerateRawRep {
  static func generateRawRepresentableExtension(
    structName: String
  ) throws -> ExtensionDeclSyntax {
    let rawRepresentableExtension = """
      extension \(structName): @MainActor Codable, RawRepresentable {
        public init?(rawValue: String) {
          guard let data = rawValue.data(using: .utf8) else { return nil }
          do {
            let decoded = try JSONDecoder().decode(Self.self, from: data)
            self = decoded
          } catch {
            print("Decoding error: \\(error)")
            return nil
          }
        }
        
        public var rawValue: String {
          do {
            let encoded = try JSONEncoder().encode(self)
            guard let string = String(data: encoded, encoding: .utf8) else {
              print("Failed to convert data to string")
              return ""
            }
            return string
          } catch {
            print("Encoding error: \\(error)")
            return ""
          }
        }
      }
      """

    return try ExtensionDeclSyntax(SyntaxNodeString(stringLiteral: rawRepresentableExtension))
  }

}
