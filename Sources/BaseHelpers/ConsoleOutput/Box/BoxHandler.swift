//
//  BoxHandler.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//


public extension ConsoleOutput {
  
  public func character(
    for part: BoxPart,
    in theme: Theme
  ) -> Character {
    
    let index = part.themeIndex
    let themeString = theme.string
    
    return themeString[themeString.index(themeString.startIndex, offsetBy: index)]
  }

  
  static func reflowText(_ text: String, width: Int) -> [String] {
    let lines = processReflow(text: text, width: width)
    return lines
  }
  
  static func reflowText(_ text: String, width: Int) -> String {
    let lines = processReflow(text: text, width: width)
    
    let joinedResult = lines.map { line in
      line
    }.joined(separator: "\n")
    
    return joinedResult
  }
  
  
  static func processReflow(text: String, width: Int) -> [String] {
    
    let paragraphs = text.components(separatedBy: .newlines)
    var reflowedLines: [String] = []
    
    for paragraph in paragraphs {
      if paragraph.isEmpty {
        reflowedLines.append("")
        continue
      }
      
      let words = paragraph.split(separator: " ")
      var currentLine = ""
      
      for word in words {
        if currentLine.isEmpty {
          currentLine = String(word)
        } else if currentLine.count + word.count + 1 <= width {
          currentLine += " \(word)"
        } else {
          reflowedLines.append(currentLine)
          currentLine = String(word)
        }
      }
      
      if !currentLine.isEmpty {
        reflowedLines.append(currentLine)
      }
    }
    
    return reflowedLines
  }
  
  
  
  public static func drawBox(
    header: String,
    content: String,
    config: Config
  ) -> String {
    
    /// This `paddingSize` value compensates for:
    ///
    /// 1. The leading wall character
    /// 2. A leading space
    /// 3  A trailing space
    /// 4. The trailing wall character
    ///
    let paddingSize: Int = 4
    
    var result = ""
    
    let headerLines: [String] = reflowText(header, width: config.width - paddingSize)
    
    let contentLines: [String] = reflowText(content, width: config.width - paddingSize)
    
    
    var headerText = ""

    //      let paddedLine = line.padding(
    //        toLength: width-paddingSize,
    //        withPad: " ",
    //        startingAt: 0
    //      )
    //      headerText += paddedLine
    //    }
    //    let header = "\(leftOrRightWall) \(headerText) \(leftOrRightWall)"
    
    for line in headerLines {
      
      
      //      result += character(for: .vertical(join: .none, location: .exterior), style: style)
      //      result += " \(line.padding(toLength: width - 4, withPad: " ", startingAt: 0)) "
      //      result += character(for: .vertical(join: .none, location: .exterior), style: style) + "\n"
      //    }
    }
    
    let finalOutput = """
    \(headerLines)
    """
    
//
//    // Top of the box
//    result += character(for: .corner(.topLeading), style: style)
//    result += String(repeating: character(for: .horizontal(join: .none, location: .exterior), style: style), count: width - 2)
//    result += character(for: .corner(.topTrailing), style: style) + "\n"
//    
//    // Content
//    for line in lines {
//      result += character(for: .vertical(join: .none, location: .exterior), style: style)
//      result += " \(line.padding(toLength: width - 4, withPad: " ", startingAt: 0)) "
//      result += character(for: .vertical(join: .none, location: .exterior), style: style) + "\n"
//    }
//    
//    // Bottom of the box
//    result += character(for: .corner(.bottomLeading), style: style)
//    result += String(repeating: character(for: .horizontal(join: .none, location: .exterior), style: style), count: width - 2)
//    result += character(for: .corner(.bottomTrailing), style: style)
//    

    
//    
//    let topLine = createHorizontal(for: topAndBottom, with: width)
//    let boxTop = "\(cornerTopLeft)\(topLine)\(cornerTopRight)"
//    
//    let seperatorLine = createHorizontal(for: innerJoin, with: width)
//    var seperator = "\(leftWallJoin)\(seperatorLine)\(rightWallJoin)"
//    
//    let bottomLine = createHorizontal(for: topAndBottom, with: width)
//    let boxBottom = "\(cornerBottomLeft)\(bottomLine)\(cornerBottomRight)"
//    
//    // Top of the box
//    result += character(for: .topLeft, style: style)
//    result += String(repeating: character(for: .topWall, style: style), count: width - 2)
//    result += character(for: .topRight, style: style) + "\n"
//    
//    // Content
//    for line in contentLines {
//      result += character(for: .leftWall, style: style)
//      result += " \(line.padding(toLength: width - 4, withPad: " ", startingAt: 0)) "
//      result += character(for: .rightWall, style: style) + "\n"
//    }
//    
//    let seperatorLine = createHorizontal(for: innerJoin, with: width)
//    var seperator = "\(leftWallJoin)\(seperatorLine)\(rightWallJoin)"
//    
//    // Bottom of the box
//    result += character(for: .bottomLeft, style: style)
//    result += String(repeating: character(for: .bottomWall, style: style), count: width - 2)
//    result += character(for: .bottomRight, style: style)
//    
    return finalOutput
  }
  

//    let headerLines: [String] = reflowText(header, width: width - paddingSize)
//    let contentLines: [String] = reflowText(content, width: width - paddingSize)
//    
//    /// Horizontal lines
//    ///
//    let topLine = createHorizontal(for: topAndBottom, with: width)
//    let boxTop = "\(cornerTopLeft)\(topLine)\(cornerTopRight)"
//    
//    let seperatorLine = createHorizontal(for: innerJoin, with: width)
//    var seperator = "\(leftWallJoin)\(seperatorLine)\(rightWallJoin)"
//    
//    let bottomLine = createHorizontal(for: topAndBottom, with: width)
//    let boxBottom = "\(cornerBottomLeft)\(bottomLine)\(cornerBottomRight)"
//    
    /// Header
    ///
//    var headerText = ""
//    for line in headerLines {
//      var paddingCharacter = spaceOrEllipsis(for: line, width: width, padding: paddingSize)
//      let paddedLine = line.padding(
//        toLength: width-paddingSize,
//        withPad: " ",
//        startingAt: 0
//      )
//      headerText += paddedLine
//    }
//    let header = "\(leftOrRightWall) \(headerText) \(leftOrRightWall)"
    
    /// Content
    ///
//    var contentOnly = ""
//    
//    for line in contentLines {
//      
//      //      var paddingCharacter = spaceOrEllipsis(for: line, width: width, padding: paddingSize)
//      
//      
//      let paddedLine = line.padding(
//        toLength: width - paddingSize,
//        withPad: " ",
//        startingAt: 0
//      )
//      
//      contentOnly += "\(leftOrRightWall) \(paddedLine) \(leftOrRightWall)\n"
//    }
//    let content = contentOnly
//    //    let content = "\(leftOrRightWall) \(contentOnly) \(leftOrRightWall)"
//    
//    let finalResult = """
//    \(boxTop)
//    \(header)
//    \(seperator)
//    \(content)
//    \(boxBottom)
//    """

//  func createHorizontal(
////    for part: ConsoleOutput.BoxPart,
//    
//    for structure: ConsoleOutput.BoxStructure,
//    with style: ConsoleOutput.Style,
//    hasCaps: Bool,
//    width: Int
//  ) -> String {
//    
//    var caps: (String, String)
//    
//    if hasCaps {
//      
//      let capLeading = ConsoleOutput.BoxPart.character(for: .horizontal(join: ., location: <#T##BoxPart.Location#>), style: style)
//      let capTrailing = ConsoleOutput.BoxPart.character(for: part, style: style)
//      
//      caps = (, )
//    }
//    var horizontal = String(repeating: part, count: width-2)
//    return horizontal
//  }
  
//  public static func structure(
//    _ structure: Structure,
//    config: Config,
//    hasCaps: Bool,
//  ) -> String {
//    
//    var capLeading = ""
//    var capTrailing = ""
//    var repeatedPart = ""
//    
////    capLeading = Part.character(with: style)
//    
//    
//    //        switch self {
//    //          case .top:
//    //
//    //
//    //
//    //
//    //          case .divider:
//    //            <#code#>
//    //          case .bottom:
//    //            <#code#>
//    //        } // END switch
//    
//    let result = capLeading + repeatedPart + capTrailing
//    
//    return result
//  }
  
  func spaceOrEllipsis(for content: String, width: Int, padding: Int) -> String {
    if content.count > width - padding {
      return "…"
    } else {
      return String(repeating: " ", count: width - padding - content.count)
    }
  }
  
  
  
  
  //      private func buildStructure(
  //        capLeading: BoxPart.Corner,
  //        capTrailing: BoxPart.Corner,
  //        repeatingPart: String
  //
  //        _ axis: ConsoleOutput.BoxStructure.Horizontal,
  //        with style: ConsoleOutput.Style
  //      ) -> String {
  //
  //
  //
  //      }
}
