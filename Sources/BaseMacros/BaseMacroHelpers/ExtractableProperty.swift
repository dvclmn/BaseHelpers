//
//  ExtractableProperty.swift
//  BaseMacros
//
//  Created by Dave Coleman on 18/9/2025.
//

public struct ExtractableProperty {
  public let name: String
  
  /// The underlying type as a string (without any Optional “?”)
  public let type: String
  
  public let isOptional: Bool
  
  /// The custom key name (if the attribute was provided)
  public let customKey: String?
  public let defaultValue: String?
}
