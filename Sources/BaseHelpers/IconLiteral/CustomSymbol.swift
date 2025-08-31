//
//  CustomSymbol.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

public enum CustomSymbol: String, Sendable, Codable, IconGalleryViewable {
  case artboard
  case zoom  // search, magnifying glass
  case terminal  // code
  case circleInRectangle
  
  public var id: String { rawValue }
  
  public var reference: String {
    let prefix: String = "custom."
    let name: String =
    switch self {
      case .artboard: "artboard"
      case .zoom: "magnifyingglass"
      case .terminal: "code.view"
      case .circleInRectangle: "circle.rectangle"
    }
    return prefix + name
  }
}
