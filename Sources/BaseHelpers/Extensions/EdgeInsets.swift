//
//  EdgeInsets.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/8/2025.
//

import SwiftUI

extension EdgeInsets {
  
  public static var zero: EdgeInsets {
    EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
  }

  public init(
    top: CGFloat = 0,
    leading: CGFloat = 0,
    bottom: CGFloat = 0,
    trailing: CGFloat = 0
  ) {
    self.init()
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
  
}
