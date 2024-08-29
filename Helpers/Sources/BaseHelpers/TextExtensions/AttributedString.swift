//
//  AttributedString.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI

public extension AttributedString {
//  var addLineBreak: AttributedString {
//    
//    var current: AttributedString = self
//    
//    current.characters.append("\n")
//    
//    return current
//  }
  
  var asString: String {
    String(self.characters)
  }
  
  mutating func appendString(_ newString: String) {
    self.characters.append(contentsOf: newString)
  }
  
  mutating func addLineBreak() {
    
    self.appendString("\n")
//    self.characters.append("\n")
  }
  
//  
//  func appendString(_ newString: String) -> AttributedString {
//
//    var result = self
//    
//    result.characters.append(contentsOf: newString)
//    
//    return result
//  }
  
}
