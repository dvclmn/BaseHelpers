//
//  AnyShapeStyle.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/8/2025.
//

import SwiftUI

extension AnyShapeStyle {
  public static var clear: Self {
    Self(Color.clear)
  }

  public var barelyThereOpacity: Self {
    Self(self.opacity(.barelyThereOpacity))
  }
  public var faintOpacity: Self {
    Self(self.opacity(.faintOpacity))
  }
  public var lowOpacity: Self {
    Self(self.opacity(.lowOpacity))
  }
  public var midOpacity: Self {
    Self(self.opacity(.midOpacity))
  }
  public var nearOpaque: Self {
    Self(self.opacity(.nearOpaque))
  }
}
