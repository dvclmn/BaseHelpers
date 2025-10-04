//
//  StrCon+Alignment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import SwiftUI

extension Alignment: StringConvertible {
  public var stringValue: String { self.displayName }
}
