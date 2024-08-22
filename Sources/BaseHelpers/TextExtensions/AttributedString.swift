//
//  AttributedString.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI

extension AttributedString {
  var addNewLine: AttributedString {
    
    var current: AttributedString = self

    current += AttributedString("\n")
    
    return current
  }
}
