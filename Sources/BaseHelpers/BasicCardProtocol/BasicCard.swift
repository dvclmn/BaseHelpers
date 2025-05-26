//
//  BasicCard.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

import Foundation

public protocol BasicCard: Identifiable {
  var id: String { get }
  var label: QuickLabel { get }
//  var name: String { get }
//  var icon: String { get }
  var blurb: String { get }
}
extension BasicCard {
  public var name: String { label.text }
  public var icon: String? { label.icon?.string }
}
