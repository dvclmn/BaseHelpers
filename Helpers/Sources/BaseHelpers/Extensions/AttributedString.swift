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
  
  var string: String {
    String(self.characters)
  }
  
  mutating func appendString(_ newString: String, addsLineBreak: Bool) {
    let lineBreak = addsLineBreak ? "\n" : ""
    self.characters.append(contentsOf: newString + lineBreak)
  }
  
  mutating func appendString(_ newCharacter: Character, addsLineBreak: Bool) {
    
    self.characters.append(newCharacter)
    if addsLineBreak {
      self.characters.append("\n")
    }
    
  }
  
  mutating func addLineBreak() {
    
    self.appendString("\n", addsLineBreak: false)
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
