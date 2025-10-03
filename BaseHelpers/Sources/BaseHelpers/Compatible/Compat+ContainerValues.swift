//
//  ContainerValue.swift
//  Components
//
//  Created by Dave Coleman on 21/11/2024.
//

import SwiftUI

// MARK: - Protocol

public protocol ContainerValueCompatible {
  associatedtype Value

  @available(macOS 15, iOS 18, *)
  var containerKeyPath: WritableKeyPath<ContainerValues, Value> { get }

}

// MARK: - Custom ContainerValues
@available(macOS 15, iOS 18, *)
extension ContainerValues {
  @Entry public var isGrouped: Bool = false
  @Entry public var isHighlighted: Bool = false
  @Entry public var shouldWiggle: Bool = false
  @Entry public var hasDividers: Bool = true
  @Entry public var hasSpacers: Bool = true
  @Entry public var hasAlternatingRowStyle: Bool = false
  @Entry public var isFirst: Bool = false
  @Entry public var isLast: Bool = false
  @Entry public var isShowingSectionHeader: Bool = true
}

public enum ContainerValueBool: ContainerValueCompatible {
  case isGrouped
  case isHighlighted
  case shouldWiggle
  case hasDividers
  case hasSpacers
  case hasAlternatingRowStyle
  case isFirst
  case isLast
  case isShowingSectionHeader
}

extension ContainerValueBool {
  public typealias Value = Bool

  @available(macOS 15, iOS 18, *)
  public var containerKeyPath: WritableKeyPath<ContainerValues, Bool> {
    switch self {
      case .isGrouped: \ContainerValues.isGrouped
      case .isHighlighted: \ContainerValues.isHighlighted
      case .shouldWiggle: \ContainerValues.shouldWiggle
      case .hasDividers: \ContainerValues.hasDividers
      case .hasSpacers: \ContainerValues.hasSpacers
      case .hasAlternatingRowStyle: \ContainerValues.hasAlternatingRowStyle
      case .isFirst: \ContainerValues.isFirst
      case .isLast: \ContainerValues.isLast
      case .isShowingSectionHeader: \ContainerValues.isShowingSectionHeader
    }
  }
}

// MARK: - ViewModifier

public struct ContainerValueModifier<T: ContainerValueCompatible>: ViewModifier {
  let type: T
  let value: T.Value

  public func body(content: Content) -> some View {
    if #available(macOS 15, iOS 18, *) {
      content.containerValue(type.containerKeyPath, value)
    } else {
      content
    }
  }
}

extension View {
  public func containerValueBool(_ type: ContainerValueBool, _ value: Bool) -> some View {
    modifier(ContainerValueModifier(type: type, value: value))
  }
}
