//
//  IdentifiedElement.swift
//  Collection
//
//  Created by Dave Coleman on 16/10/2024.
//

import Foundation
import SwiftUICore
import ComposableArchitecture

public protocol IdentifiedElement: Identifiable, Equatable, Sendable {
  
  init(name: String, grainientSeed: Int?)
  
  var id: UUID { get }
  var name: String { get set }
  var grainientSeed: Int? { get set }
  var dateDeleted: Date? { get set }
}

public extension IdentifiedElement {
  var isDeleted: Bool {
    dateDeleted != nil
  }
}


/// This is a type-erasing wrapper for ``IdentifiedElement``
public struct AnyIdentifiedElement: Identifiable, Equatable, Hashable, Sendable {
  public let id: UUID
  let name: String
  
  public init<T: IdentifiedElement>(_ element: T) {
    self.id = element.id
    self.name = element.name
  }
  
  public static func == (
    lhs: AnyIdentifiedElement,
    rhs: AnyIdentifiedElement
  ) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
  }
}


//public struct SelectedElementsKey: EnvironmentKey {
//  public static let defaultValue: Set<AnyIdentifiedElement> = []
//}
//
//public extension EnvironmentValues {
//  var selectedElements: Set<AnyIdentifiedElement> {
//    get { self[SelectedElementsKey.self] }
//    set { self[SelectedElementsKey.self] = newValue }
//  }
//}
//
//public struct SelectedElementsTCAKey: DependencyKey {
//  
//  static let liveValue = Set<AnyIdentifiedElement> = []
//}
//
//extension DependencyValues {
//  var selectedElements: Set<AnyIdentifiedElement> {
//    get { self[SelectedElementsTCAKey.self] }
//    set { self[SelectedElementsTCAKey.self] = newValue }
//  }
//}
