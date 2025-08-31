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
  public var opacityFaint: Self {
    Self(self.opacity(.opacityFaint))
  }
  public var opacityLow: Self {
    Self(self.opacity(.opacityLow))
  }
  public var opacityMid: Self {
    Self(self.opacity(.opacityMid))
  }
  public var nearOpaque: Self {
    Self(self.opacity(.nearOpaque))
  }
}
