//
//  BoxHandler.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation
import SwiftUICore

public extension ConsoleOutput {
  
  /// This `paddingSize` value compensates for:
  ///
  /// 1. The leading wall character
  /// 2. A leading space
  /// 3  A trailing space
  /// 4. The trailing wall character
  ///
  private static let paddingSize: Int = 4
  
  func drawBox() -> AttributedString {
    
    var output = AttributedString()
    let width: Int = self.config.width - ConsoleOutput.paddingSize
    
    /// 1. Create top-most line — the roof of the box
    ///
    output += widthCounter(self.config.width)
    output += self.processBoxLine(type: .top)
    output.addNewLine()
    
    let headerLines: [String] = self.header.reflowText(width: width, maxLines: config.headerLineLimit)
    let contentLines: [String] = self.content.reflowText(width: width, maxLines: config.contentLineLimit)
    
    for line in headerLines {
      output += self.processBoxLine(line, type: .header)
      output.addNewLine()
    }
    
    output += self.processBoxLine(type: .divider)
    output += AttributedString("\n")
    
    for line in contentLines {
      output += self.processBoxLine(line, type: .content)
      output += AttributedString("\n")
    }
    
    output += self.processBoxLine(type: .bottom)
    
    return output
  }
  
  /// From the top down, what are the line types that can be generated?
  ///
  /// - top line
  /// - header lines
  /// - divider
  /// - content lines
  /// - bottom line
  ///
  func processBoxLine(_ reflowedLine: String? = nil, type: Line) -> AttributedString {
    
    var output = AttributedString()
    var capLeading: Part
    var capTrailing: Part
    
    /// Caps (these are not the lines themselves, just the caps)
    ///
    switch type {
      case .top:
        capLeading = Part.corner(.top(.leading))
        capTrailing = Part.corner(.top(.trailing))
        
      case .header, .content:
        capLeading = Part.vertical(location: .exterior)
        capTrailing = Part.vertical(location: .exterior)
        
      case .divider:
        capLeading = Part.vertical(join: .leading, location: .exterior)
        capTrailing = Part.vertical(join: .trailing, location: .exterior)
        
      case .bottom:
        capLeading = Part.corner(.bottom(.leading))
        capTrailing = Part.corner(.bottom(.trailing))
    }
    
    output = cappedLine(capLeading, reflowedLine, capTrailing, for: type)
    
    return output
  }
  
  private func cappedLine(
    _ capLeading: Part,
    _ text: String?,
    _ capTrailing: Part,
    for type: Line
  ) -> AttributedString {
    
    var output = AttributedString("")
    let paddingCharacter = Theme.Invisibles.padding.character
    
    if let text = text {
      
      let paddingLength = self.config.width
      
      output.appendString(text)
      output.setAttributes(config.theme.colours.text.container)
      
      // Calculate the padding length
      let paddingNeeded = max(0, paddingLength - text.count)
      
      if paddingNeeded > 0 {
        // Create an AttributedString for the padding
        var paddingString = AttributedString(String(repeating: paddingCharacter, count: paddingNeeded))
        
        // Apply attributes to the padding
        paddingString.setAttributes(config.theme.colours.invisibles.container)
        
        // Append the padded part with attributes
        output += paddingString
      }

      
//      output[paddedText.ra]
//      output.appendString(paddedText)
//      output += AttributedString(paddedText, attributes: config.theme.colours.invisibles.container)
      
      //
      //      // Apply default text color to the actual text
      //      if let textRange = attributedPaddedText.range(of: text) {
      //        attributedPaddedText[textRange].foregroundColor = textForeground
      //      }
      
    } else {
      output += repeatingPart(for: type)
    }
    
    
    return output
  }
  
  //    var lineContent: String = ""
  //
  //    if let text = text {
  //      let leadingSpace = " "
  //
  //      let paddingLength: Int = self.config.width
  //
  //      lineContent = leadingSpace + text.padding(toLength: paddingLength, withPad: "*", startingAt: 0) + "\n"
  //
  //    } else {
  //      lineContent = repeatingPart(for: type)
  //    }
  //
  //
  //    let output = capLeading.character(with: config) + lineContent + capLeading.character(with: config)
  //
  //    return output
  //  }
  
  
  
  
  
  
  private func repeatingPart(for line: Line) -> AttributedString {
    
    var output = AttributedString("")
    
    let repeatCount: Int = self.config.width - (Self.paddingSize - 2)
    
    switch line {
      case .top, .bottom:
        let part = Part.horizontal(location: .exterior).character(with: config)
        output += AttributedString(String(repeating: part, count: repeatCount))
        
      case .header, .content:
        break // header and content should produce actual text content, not a structural Part
        
      case .divider:
        let part = Part.horizontal(location: .interior).character(with: config)
        output += AttributedString(String(repeating: part, count: repeatCount))
    }
    
    output.setAttributes(config.theme.colours.frame.container)
    return output
  }
  
  enum WidthCounterDisplayStyle {
    case full
    case compact
  }
  
  func widthCounter(
    _ width: Int,
    style: WidthCounterDisplayStyle = .compact
  ) -> AttributedString {
    
    var result = AttributedString("")
    let adjustedWidth = width + 1 // To make up for starting from 1
    
    switch style {
      case .full:
        // First line: 10's (with leading zero)
        var tensLine = ""
        for i in 1..<adjustedWidth {
          tensLine += String((i / 10) % 10)
        }
        result.appendString(tensLine)
        result.addNewLine()
        
        // Second line: counting up by one
        var onesLine = ""
        for i in 1..<adjustedWidth {
          onesLine += String(i % 10)
        }
        result.appendString(onesLine)
        result.addNewLine()
        
      case .compact:
        var compactLine = "1"
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
        result.appendString(compactLine)
        result.addNewLine()
        result.appendString(
          String.repeating(
            ".",
            alternating: "|",
            every: 5,
            count: width
          )
        )
        result.addNewLine()
    }

    
    result.setAttributes(config.theme.colours.invisibles.container)
    return result
  }
  

}
