//
//  CGRect.swift
//  Collection
//
//  Created by Dave Coleman on 9/12/2024.
//

import SwiftUI

public extension CGRect {
  var path: Path {
    Path(self)
  }
}
