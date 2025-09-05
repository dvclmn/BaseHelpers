//
//  ModelBase.swift
//  BaseComponents
//
//  Created by Dave Coleman on 15/8/2025.
//

import Foundation

public protocol ModelBase: Sendable, Codable, Equatable, Hashable {}
public protocol ModelWithID: ModelBase, Identifiable where ID: Hashable {
  var id: ID { get }
}

public protocol Editable: ModelBase {
  var dateAdded: Date { get }
  var dateDeleted: Date? { get set }
  var dateModified: Date? { get set }
}
