//
//  KeyEquivalent.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/7/2025.
//

import SwiftUI

extension Set where Element == KeyEquivalent {
  public var isHoldingSpace: Bool {
    self.contains(.space)
  }
}

