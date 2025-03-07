//
//  AttributeContainer+Presets.swift
//  TextCore
//
//  Created by Dave Coleman on 30/8/2024.
//

import Foundation
import SwiftUI



public extension AttributeContainer {
  
  static var underlineDebug: AttributeContainer {
    var container = AttributeContainer()
    container.strikethroughStyle = .single
    container.strikethroughColor = .red
    
    return container
  }
  
  static var highlighter: AttributeContainer {
    return quickContainer(with: .black, background: .green)
  }
  
  static var neonOrangeSoft: AttributeContainer {
    return quickContainer(with: .black, background: .orange.opacity(0.7))
  }
  
  static var neonOrange: AttributeContainer {
    return quickContainer(with: .white, background: .orange.opacity(0.5))
  }
  
  static var invisible: AttributeContainer {
    return quickContainer(with: .clear, background: .clear)
  }
  
  static var blackOnWhite: AttributeContainer {
    return quickContainer()
  }
  
  static var whiteOnBlack: AttributeContainer {
    return quickContainer(with: .white, background: .black)
  }
  
  static func quickContainer(
    with foreground: Color = .black,
    background: Color = .white
  ) -> AttributeContainer {
    
    var container = AttributeContainer()
    container.foregroundColor = foreground
    container.backgroundColor = background
    
    return container
    
  }

  func getAttributes<S: AttributeScope>(for scope: KeyPath<AttributeScopes, S.Type>) -> [NSAttributedString.Key: Any]? {
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
