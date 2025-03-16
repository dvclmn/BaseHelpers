//
//  AttributeContainer+Presets.swift
//  TextCore
//
//  Created by Dave Coleman on 30/8/2024.
//

import Foundation
import SwiftUI

extension AttributeContainer {

  public static var underlineDebug: AttributeContainer {
    var container = AttributeContainer()
    container.strikethroughStyle = .single
    container.strikethroughColor = .red

    return container
  }

  public static var highlighter: AttributeContainer {
    return quickContainer(foreground: .black, background: .green)
  }

  public static var searchMatch: AttributeContainer {
    return quickContainer(foreground: .black, background: .yellow)
  }

  public static var neonOrangeSoft: AttributeContainer {
    return quickContainer(foreground: .black, background: .orange.opacity(0.7))
  }

  public static var neonOrange: AttributeContainer {
    return quickContainer(foreground: .white, background: .orange.opacity(0.5))
  }

  public static var faded: AttributeContainer {
    return quickContainer(foreground: .white.opacity(0.4), background: .clear)
  }

  public static var invisible: AttributeContainer {
    return quickContainer(foreground: .clear, background: .clear)
  }

  public static var blackOnWhite: AttributeContainer {
    return quickContainer()
  }

  public static var whiteOnBlack: AttributeContainer {
    return quickContainer(foreground: .white, background: .black)
  }

  public static func quickContainer(
    foreground: Color = .black,
    background: Color = .white
  ) -> AttributeContainer {

    var container = AttributeContainer()
    container.foregroundColor = foreground
    container.backgroundColor = background

    return container

  }

  public func getAttributes<S: AttributeScope>(
    for scope: KeyPath<AttributeScopes, S.Type>
  ) -> [NSAttributedString.Key: Any]? {
    do {
      return try Dictionary(self, including: scope)
    } catch {
      return nil
    }
  }

  #if canImport(UIKit)
  func getAttributes() -> [NSAttributedString.Key: Any]? {
    return getAttributes(for: \.uiKit)
  }

  #elseif canImport(AppKit)
  func getAttributes() -> [NSAttributedString.Key: Any]? {
    return getAttributes(for: \.appKit)
  }

  #endif

}
