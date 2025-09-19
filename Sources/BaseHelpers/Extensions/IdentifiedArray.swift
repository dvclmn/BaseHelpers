//
//  IdentifiedArray.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/9/2025.
//

import Foundation
import IdentifiedCollections

extension Collection where Element: Identifiable {
  public var toIdentifiedArray: IdentifiedArrayOf<Self.Element> {
    return IdentifiedArrayOf(uniqueElements: self)
  }
}
