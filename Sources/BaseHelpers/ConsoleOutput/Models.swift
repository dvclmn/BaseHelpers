//
//  Models.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//


public struct ConsoleOutput {
  
  public enum BoxPart {
    case topLeft, topRight, bottomLeft, bottomRight
    case leftWall, rightWall, topWall, bottomWall
    case leftJoin, rightJoin
    case horizontalDivider
  }
  
  public enum Style: String, CaseIterable {
    case rounded
    case sharp
    case double
    case ascii
    case stars
    case hearts
    // Add more styles as needed
  }
  
  private static let styleCharacters: [Style: [BoxPart: String]] = [
    .rounded: [
      .topLeft: "╭", .topRight: "╮", .bottomLeft: "╰", .bottomRight: "╯",
      .leftWall: "│", .rightWall: "│", .topWall: "─", .bottomWall: "─",
      .leftJoin: "├", .rightJoin: "┤",
      .horizontalDivider: "─"
    ],
    .sharp: [
      .topLeft: "┏", .topRight: "┓", .bottomLeft: "┗", .bottomRight: "┛",
      .leftWall: "┃", .rightWall: "┃", .topWall: "━", .bottomWall: "━",
      .leftJoin: "┠", .rightJoin: "┨",
      .horizontalDivider: "─"
    ],
    .double: [
      .topLeft: "╔", .topRight: "╗", .bottomLeft: "╚", .bottomRight: "╝",
      .leftWall: "║", .rightWall: "║", .topWall: "═", .bottomWall: "═",
      .leftJoin: "╠", .rightJoin: "╣",
      .horizontalDivider: "═"
    ],
    .ascii: [
      .topLeft: "+", .topRight: "+", .bottomLeft: "+", .bottomRight: "+",
      .leftWall: "|", .rightWall: "|", .topWall: "-", .bottomWall: "-",
      .leftJoin: "+", .rightJoin: "+",
      .horizontalDivider: "-"
    ],
    .stars: [
      .topLeft: "★", .topRight: "★", .bottomLeft: "★", .bottomRight: "★",
      .leftWall: "☆", .rightWall: "☆", .topWall: "⋆", .bottomWall: "⋆",
      .leftJoin: "★", .rightJoin: "★",
      .horizontalDivider: "⋆"
    ],
    .hearts: [
      .topLeft: "❤", .topRight: "❤", .bottomLeft: "❤", .bottomRight: "❤",
      .leftWall: "♥", .rightWall: "♥", .topWall: "♡", .bottomWall: "♡",
      .leftJoin: "❤", .rightJoin: "❤",
      .horizontalDivider: "♡"
    ]
  ]
  
  public static func character(for part: BoxPart, style: Style) -> String {
    return styleCharacters[style]?[part] ?? " "
  }
  
  public enum Structure {
    case top
    case wall
    case bottom
    
    case horizontalDivider
    
    
    
  }
  
  static let cornerTopLeft:       String = "┏"
  static let cornerTopRight:      String = "┓"
  
  static let cornerBottomLeft:    String = "┗"
  static let cornerBottomRight:   String = "┛"
  
  static let leftWallJoin:        String = "┠"
  
  static let rightWallJoin:       String = "┨"
  
  static let leftOrRightWall:     String = "┃"
  
  static let innerJoin:           String = "─"
  static let topAndBottom:        String = "━"
  
  
  static func header(_ info: String) -> String {
    return """
    
    \(headerExteriorLine)
    \(info)
    \(headerInteriorLine)
    """
  }
  
  
  static let headerExteriorLine: String = "=============================================================="
  static let headerInteriorLine: String = "--------------------------------------------------------------"
  static let footerLine: String = "◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡◠◡"
  
  
  
  static let footerLineAlt: String = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  
  
  
  
  
  
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
      
      //      if paragraph.hasPrefix("#") || paragraph.matches(of: /^\d+\./).count > 0 {
      //        // Preserve headers and numbered lists
      //        reflowedLines.append(paragraph)
      //        continue
      //      }
      
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
  
  
  
  //  static func reflowText(_ text: String, width: Int) -> (lines: [String], joined: String) {
  //    let words = text.split(separator: " ")
  //    var lines: [String] = []
  //    var currentLine = ""
  //
  //    for word in words {
  //      if currentLine.isEmpty {
  //        currentLine = String(word)
  //      } else if currentLine.count + word.count + 1 <= width {
  //        currentLine += " \(word)"
  //      } else {
  //        lines.append(currentLine)
  //        currentLine = String(word)
  //      }
  //    }
  //
  //    if !currentLine.isEmpty {
  //      lines.append(currentLine)
  //    }
  //
  //    let joinedResult = lines.map { line in
  //      line
  //    }.joined(separator: "\n")
  //
  //    return (lines, joinedResult)
  //  }
  
  
  static func draw(header: String, content: String, width: Int = 40) -> String {
    
    /// This `paddingSize` value compensates for:
    ///
    /// 1. The leading wall character
    /// 2. A leading space
    /// 3. An ellipsis or space character
    /// 4 A trailing space
    /// 5. The trailing wall character
    ///
    let paddingSize: Int = 4
    
    let headerLines: [String] = reflowText(header, width: width - paddingSize)
    let contentLines: [String] = reflowText(content, width: width - paddingSize)
    
    /// Horizontal lines
    ///
    let topLine = createHorizontal(for: topAndBottom, with: width)
    let boxTop = "\(cornerTopLeft)\(topLine)\(cornerTopRight)"
    
    let seperatorLine = createHorizontal(for: innerJoin, with: width)
    var seperator = "\(leftWallJoin)\(seperatorLine)\(rightWallJoin)"
    
    let bottomLine = createHorizontal(for: topAndBottom, with: width)
    let boxBottom = "\(cornerBottomLeft)\(bottomLine)\(cornerBottomRight)"
    
    /// Header
    ///
    var headerText = ""
    for line in headerLines {
      var paddingCharacter = spaceOrEllipsis(for: line, width: width, padding: paddingSize)
      let paddedLine = line.padding(
        toLength: width-paddingSize,
        withPad: " ",
        startingAt: 0
      )
      headerText += paddedLine
    }
    let header = "\(leftOrRightWall) \(headerText) \(leftOrRightWall)"
    
    /// Content
    ///
    var contentOnly = ""
    
    for line in contentLines {
      
      //      var paddingCharacter = spaceOrEllipsis(for: line, width: width, padding: paddingSize)
      
      
      let paddedLine = line.padding(
        toLength: width - paddingSize,
        withPad: " ",
        startingAt: 0
      )
      
      contentOnly += "\(leftOrRightWall) \(paddedLine) \(leftOrRightWall)\n"
    }
    let content = contentOnly
    //    let content = "\(leftOrRightWall) \(contentOnly) \(leftOrRightWall)"
    
    let finalResult = """
    \(boxTop)
    \(header)
    \(seperator)
    \(content)
    \(boxBottom)
    """
    
    return finalResult
  }
  
  static func createHorizontal(
    for structure: String,
    with width: Int
  ) -> String {
    
    var horizontal = String(repeating: structure, count: width-2)
    return horizontal
  }
  
  
  static func spaceOrEllipsis(for content: String, width: Int, padding: Int) -> String {
    if content.count > width - padding {
      return "…"
    } else {
      return String(repeating: " ", count: width - padding - content.count)
    }
  }
}
