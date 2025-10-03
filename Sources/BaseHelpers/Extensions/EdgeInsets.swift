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

  /// This permits the omission of any one of the four
  /// parameters, which the default init doesn't allow for.
  ///
  /// The underscores are to try and disambiguate
  /// from the native which otherwise has the same shape
  public init(
    top: CGFloat = 0,
    left: CGFloat = 0,
    bottom: CGFloat = 0,
    right: CGFloat = 0
  ) {
    self.init(
      top: top,
      leading: left,
      bottom: bottom,
      trailing: right
    )
  }

  public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
    self.init(
      top: vertical,
      leading: horizontal,
      bottom: vertical,
      trailing: horizontal
    )
  }

}
