//
//  Subview.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/8/2025.
//

import SwiftUI

@available(macOS 15.0, iOS 18.0, *)
extension Subview {
  public func isLastInCollection(_ collection: SubviewsCollection) -> Bool {
    return collection.last?.id == self.id
  }
}
