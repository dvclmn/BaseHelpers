//
//  BoxHandler.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation

public extension ConsoleOutput {
  
  /// This `paddingSize` value compensates for:
  ///
  /// 1. The leading wall character
  /// 2. A leading space
  /// 3  A trailing space
  /// 4. The trailing wall character
  ///
  private static let paddingSize: Int = 4
  
  func drawBox() -> String {
    
    
    var headerOutput = ""
    var contentOutput = ""
    
    let topLine = self.processBoxLine(type: .top)
    let dividerLine = self.processBoxLine(type: .divider)
    let bottomLine = self.processBoxLine(type: .bottom)
    
    
    let headerLines: [String] = self.header.reflowText(
      width: self.config.width - ConsoleOutput.paddingSize,
      maxLines: config.headerLineLimit
    )
    let contentLines: [String] = self.content.reflowText(
      width: self.config.width - ConsoleOutput.paddingSize,
      maxLines: config.contentLineLimit
    )
    
    for line in headerLines {
      headerOutput += self.processBoxLine(line, type: .header)
    }
    
    for line in contentLines {
      contentOutput += self.processBoxLine(line, type: .header)
    }
    
    let finalOutput = """
    \(topLine)
    \(headerOutput)
    \(dividerLine)
    \(contentOutput)
    \(bottomLine)
    """
    
    return finalOutput
  }
  
  /// From the top down, what are the line types that can be generated?
  ///
  /// - top line
  /// - header lines
  /// - divider
  /// - content lines
  /// - bottom line
  ///
  func processBoxLine(_ reflowedLine: String? = nil, type: Line) -> String {
    
    var output: String = ""
    var capLeading: Part
    var capTrailing: Part
    
    switch type {
      case .top:
        capLeading = Part.corner(.top(.leading))
        capTrailing = Part.corner(.top(.trailing))
        
      case .header:
        capLeading = Part.vertical(location: .exterior)
       capTrailing = Part.vertical(location: .exterior)
        
      case .divider:
        capLeading = Part.vertical(join: .leading, location: .exterior)
        capTrailing = Part.vertical(join: .trailing, location: .exterior)
        
      case .content:
        capLeading = Part.corner(.top(.leading))
        capTrailing = Part.corner(.top(.trailing))
        
      case .bottom:
        capLeading = Part.corner(.top(.leading))
        capTrailing = Part.corner(.top(.trailing))
    }
    
    output = cappedLine(capLeading, reflowedLine, capTrailing, for: type)
    
    return output
  }
  
  private func cappedLine(
    _ capLeading: Part,
    _ text: String?,
    _ capTrailing: Part,
    for type: Line
  ) -> String {
    
    var lineContent: String = ""
    
    
    if let text = text {
      let leadingSpace = " "
      
      let paddingLength: Int = self.config.width - Self.paddingSize
      
      lineContent = leadingSpace + text.padding(toLength: paddingLength, withPad: " ", startingAt: 0)
    } else {
      lineContent = repeatingPart(for: type)
    }
    
    
    let output = capLeading.character(with: config)
    + lineContent
    + capLeading.character(with: config)
    + "\n"
    
    return output
  }
  
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
