//
//  File.swift
//
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation
import SwiftUI

extension Range where Bound == String.Index {
  func toNSRange(in string: String) -> NSRange {
    return string.nsRange(from: self)
  }
}

