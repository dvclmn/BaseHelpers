//
//  WidthCounterStyle.swift
//  BoxCore
//
//  Created by Dave Coleman on 29/8/2024.
//

import Foundation
import SwiftUI


public extension TextCore {
  
  enum WidthCounterStyle: Sendable {
    case off
    case compact
    case full
  }
  
  static func widthCounter(
    _ width: Int,
    style: WidthCounterStyle
  ) -> AttributedString {
    
//    let style = self.config.metrics.widthCounter
    var result = AttributedString()
    
    switch style {
      case .off:
        break
        
      case .full:

        let fullOutput = self.generateFullCounter(width)
        
        result.appendString(fullOutput.tens, addsLineBreak: true)
        result.appendString(fullOutput.ones, addsLineBreak: true)
        
      case .compact:
        
        let compactOutput = self.generateCompactCounter(width)
        
        result.appendString(compactOutput, addsLineBreak: false)
        result.addLineBreak()
        
        let pattern = String.pattern(totalCount: width) {
          character("|")
          repeating(".", count: 4)
          character("╷")
          repeating(".", count: 4)
        }
        
        result.appendString(pattern, addsLineBreak: false
        )
        result.addLineBreak()
        
    }
    
    
//    result.setAttributes(container(for: .tertiary))
    return result
  }
  
  static func generateCompactCounter(_ width: Int) -> String {
    let startingFrom: Int = 0
    
    var compactLine = startingFrom.description
    var i = 5
    while i <= width {
      let spaces = String(repeating: " ", count: i <= 9 ? 4 : 3)
      if i % 10 == 5 {
        compactLine += spaces + "· "
      } else {
        // Align two-digit numbers with the first digit over the marker
        if i >= 10 {
          compactLine += String(repeating: " ", count: 3) + String(i)
        } else {
          compactLine += spaces + String(i)
        }
      }
      i += 5
    }
    
    // Handle the final number
    if width % 5 != 0 {
      let lastNumberString = String(width)
      let spacesNeeded = width - compactLine.count - lastNumberString.count
      if spacesNeeded > 0 {
        compactLine += String(repeating: " ", count: spacesNeeded) + lastNumberString
      } else {
        // If we've overshot, trim the line and add the last number
        compactLine = String(compactLine.prefix(width - lastNumberString.count)) + lastNumberString
      }
    }
    
    return compactLine
    
  }
  
  static func generateFullCounter(_ width: Int) -> (tens: String, ones: String) {
    
    let startingNumber: Int = 1
    let totalWidth = width + 1 // To make up for starting from 1
    
    // MARK: - The tens digit
    
    var tensLine = ""
    
    /// Work through each number in the provided width, starting at the
    /// `startingNumber`, up to (but not including) `totalWidth`.
    ///
    for integer in startingNumber..<totalWidth {
      
      /// Now to get the ten's place value, for each `integer`.
      ///
      /// First, we divide by ten. This removes the ones digit and shifts everything
      /// else one place to the right.
      ///
      let dividedByTen: Int = integer / 10
      
      ///
      /// Then we use `%` (modulo) to get only the rightmost digit of the result.
      ///
      /// Here's an example, using `243`:
      /// - `243 / 10 = 24` (integer division)
      /// - `24 % 10 = 4`
      ///
      /// This gives us the tens digit (`4`) of `243`.
      ///
      let remainder: Int = dividedByTen % 10
      
      /// Finally we add each result as a String to the `tensLine`
      ///
      tensLine += String(remainder)
      
    }
    
    // MARK: - The ones digit
    
    /// Second line: counting up by one
    ///
    var onesLine = ""
    for integer in startingNumber..<totalWidth {
      onesLine += String(integer % 10)
    }
    
    guard tensLine.count == width,
          onesLine.count == width
    else { fatalError("Incorrect width claculation somewhere.")}
    
    return (tensLine, onesLine)
    
  } // END full counter

}



struct WidthCounterView: View {
  
  var body: some View {
    
    Text(TextCore.widthCounter(38, style: .full))
      .textSelection(.enabled)
    
      .monospaced()
    //    .padding(40)
      .frame(width: 400, height: 600)
      .background(.black.opacity(0.6))
  }
}

#if DEBUG
#Preview {
  WidthCounterView()
}


#endif
