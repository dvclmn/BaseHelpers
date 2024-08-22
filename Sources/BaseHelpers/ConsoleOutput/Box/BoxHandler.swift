//
//  BoxHandler.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//


public extension ConsoleOutput {
  
  
  private static let paddingSize: Int = 4
  
  public func drawBox(
    header: String,
    content: String
  ) -> String {
    
    /// This `paddingSize` value compensates for:
    ///
    /// 1. The leading wall character
    /// 2. A leading space
    /// 3  A trailing space
    /// 4. The trailing wall character
    ///
    
    
    var headerOutput = ""
    var contentOutput = ""
    
    let headerLines: [String] = header.reflowText(width: self.config.width - ConsoleOutput.paddingSize)
    let contentLines: [String] = content.reflowText(width: self.config.width - ConsoleOutput.paddingSize)
    
    let topLine = self.processBoxLine(type: .top)
    
    //      let paddedLine = line.padding(
    //        toLength: width-paddingSize,
    //        withPad: " ",
    //        startingAt: 0
    //      )
    //      headerText += paddedLine
    //    }
    //    let header = "\(leftOrRightWall) \(headerText) \(leftOrRightWall)"
    
    for line in headerLines {
      headerOutput += self.processBoxLine(line, type: .header)
    }
    
    for line in contentLines {
      contentOutput += self.processBoxLine(line, type: .header)
    }
    
    let finalOutput = """
    \(topLine)
    \(headerOutput)
    \(contentOutput)
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
    
    /// If `text` is `nil`, that means we're working with a structural line, not a written-text based line
    ///
    
    var capLeading: String = ""
    var capTrailing: String = ""
    
    var output: String = ""
    
    switch type {
      case .top:
        output = cappedLine(.corner(.top(.leading)), reflowedLine, .corner(.top(.trailing)), for: type)
        
      case .header:
        output = cappedLine(.horizontal(), reflowedLine, .horizontal(), for: type)
      case .divider:
        output = cappedLine(.corner(.top(.leading)), reflowedLine, .corner(.top(.trailing)), for: type)
      case .content:
        output = cappedLine(.corner(.top(.leading)), reflowedLine, .corner(.top(.trailing)), for: type)
      case .bottom:
        output = cappedLine(.corner(.top(.leading)), reflowedLine, .corner(.top(.trailing)), for: type)
    }
    
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
      lineContent = text
    } else {
      lineContent = repeatingPart(for: type)
    }
    
    let output = capLeading.character(with: config) + lineContent + capLeading.character(with: config) + "\n"
    
    return output
  }

  
  private func repeatingPart(for line: Line) -> String {
    
    var finalOutput: String = ""
    
    switch line {
        
      case .top, .bottom:
        
        let part = Part.horizontal(location: .exterior)
        finalOutput = part.character(with: config)
        
      case .header, .content:
        break
        
      case .divider:
        let part = Part.horizontal(location: .interior)
        finalOutput = part.character(with: config)
    }
    
    return finalOutput
  }
  
  func spaceOrEllipsis(for content: String, width: Int, padding: Int) -> String {
    if content.count > width - padding {
      return "…"
    } else {
      return String(repeating: " ", count: width - padding - content.count)
    }
  }
  
  
}
