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
    output += self.processBoxLine(type: .top).addNewLine
    
    let headerLines: [String] = self.header.reflowText(width: width, maxLines: config.headerLineLimit)
    let contentLines: [String] = self.content.reflowText(width: width, maxLines: config.contentLineLimit)
    
    for line in headerLines {
      output += self.processBoxLine(line, type: .header).addNewLine
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
    
    var output = AttributedString()
    var paddingCharacter = Theme.Invisibles.padding.character
    
    if let text = text {
      
//      let leadingSpace = AttributedString("•", attributes: config.theme.colours.invisibles.container)
      
      let paddingLength = self.config.width
      let paddedText = text.padding(toLength: paddingLength, withPad: paddingCharacter, startingAt: 0)
      
      output += AttributedString(paddedText, attributes: config.theme.colours.invisibles.container)

//      
//      // Apply default text color to the actual text
//      if let textRange = attributedPaddedText.range(of: text) {
//        attributedPaddedText[textRange].foregroundColor = textForeground
//      }
      
      // Apply padding color to the padding characters
      attributedPaddedText.foregroundColor = invisiblesForeground
      
      lineContent = leadingSpace + attributedPaddedText + AttributedString("\n")
    } else {
      lineContent = AttributedString(repeatingPart(for: type))
      lineContent.foregroundColor = invisiblesForeground
    }
    
    var capLeadingAttr = AttributedString(capLeading.character(with: config))
    var capTrailingAttr = AttributedString(capTrailing.character(with: config))
    capLeadingAttr.foregroundColor = frameForeground
    capTrailingAttr.foregroundColor = frameForeground
    
    return capLeadingAttr + lineContent + capTrailingAttr
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
  
  
  
  
  
  
  private func repeatingPart(for line: Line) -> String {
    
    var finalOutput: String = ""
    let repeatCount: Int = self.config.width - (Self.paddingSize - 1)
    
    switch line {
      case .top, .bottom:
        let part = Part.horizontal(location: .exterior).character(with: config)
        finalOutput = String(repeating: part, count: repeatCount)
        
      case .header, .content:
        break // header and content should produce actual text content, not a structural Part
        
      case .divider:
        let part = Part.horizontal(location: .interior).character(with: config)
        finalOutput = String(repeating: part, count: repeatCount)
    }
    
    return finalOutput
  }
  
}
