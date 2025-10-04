// The Swift Programming Language
// https://docs.swift.org/swift-book

/// Handles `Codable` conformance
@attached(member, names: named(CodingKeys), named(init(from:)), named(encode(to:)), named(init))

/// Handles `RawRepresentable` conformance
@attached(extension, conformances: RawRepresentable, Codable, names: named(init(rawValue:)), named(rawValue), named(init(decoder:)), named(decoder))

public macro Persistable() = #externalMacro(
  /// Important: `module` corresponds to `targets: [.macro(name: "ExampleNameMacros"...)]`
  /// **Note the plural**
  module: "UtilityMacros",
  
  /// `type` corresponds to the name of the Macros struct, e.g.
  /// `public struct ExampleNameMacro: MemberMacro {...}`
  type: "PersistableMacro"
)

@attached(peer)
public macro Attribute(originalName: String) = #externalMacro(
  module: "UtilityMacros",
  type: "AttributeMacro"
)
