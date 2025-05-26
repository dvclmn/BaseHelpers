//
//  BasicCard.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

public protocol BasicCard: Identifiable {
  var id: String { get }
  var label: Quick
//  var name: String { get }
//  var icon: String { get }
  var blurb: String { get }
}
