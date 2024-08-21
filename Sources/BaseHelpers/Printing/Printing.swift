//
//  Printing.swift
//  Helpers
//
//  Created by Dave Coleman on 21/8/2024.
//

import SwiftUI

import Foundation

public struct DiagnosticInformation {
  var fileName: String
  var line: Int
  var functionName: String
  
  public init(
    fileName: String = #file,
    line: Int = #line,
    functionName: String = #function
  ) {
    self.fileName = fileName
    self.line = line
    self.functionName = functionName
  }
}


public func printValue<T: CustomStringConvertible>(
  _ value: T,
  title: String? = nil,
  diagnostics: DiagnosticInformation = .init(),
  hasTrailingLine: Bool = true
) {
  
  var valueString = "Value: \(value)"
  
  let output = formatPrintInfo(
    title,
    value: valueString,
    diagnostics: diagnostics,
    hasTrailingLine: hasTrailingLine
  )
  
  print(output)
}

// MARK: Print Header

public func printHeader(
  _ title: String? = nil,
  value: Any? = nil,
  diagnostics: DiagnosticInformation
) {
  print(formatHeader(title, value: value, diagnostics: diagnostics))
}

func formatHeader(
  _ title: String? = nil,
  value: Any? = nil,
  diagnostics: DiagnosticInformation = .init()
) -> String {
  
  let fileAndLine = "File & Line: \t[\(URL(fileURLWithPath: diagnostics.fileName).lastPathComponent):\(diagnostics.line)]"
  let functionName = "Function: \t\(diagnostics.functionName)"
  
  var typeString: String = ""
  
  if let value = value {
    let mirror = Mirror(reflecting: value)
    let typeName = String(describing: type(of: value))
    typeString = "Type: \t\t\(typeName)"
  }
  
  let headerInfo = [(title ?? ""), fileAndLine, functionName, typeString].joined(separator: "\n")
  
  let formattedHeader = ConsoleOutput.header(headerInfo)
  
  return formattedHeader
}

// MARK: Print Footer

public func printFooter(_ title: String? = nil) {
  print(formatFooter(title))
}

func formatFooter(_ title: String? = nil) -> String {
  
  
  
  var footerString: String = ""
  
  if let title = title {
    footerString = "// END: \(title)"
  }
  
  let finalLine = ConsoleOutput.footerLine
  
  let output = """
  
  \(footerString)
  \(finalLine)
  
  
  """
  
  return output
  
}

// MARK: Print Total info

func formatPrintInfo(
  _ title: String? = nil,
  value: Any,
  diagnostics: DiagnosticInformation,
  hasTrailingLine: Bool = true
) -> String {
  
  let header: String = formatHeader(
    title,
    value: value,
    diagnostics: diagnostics
  )
  
  let footer: String = hasTrailingLine ? formatFooter(title) : ""
  
  let output: String = """
  
  \(header)
  
  \(value)
  
  \(footer)
  
  """
  
  return output
}


public func printCollection<T: Collection>(
  _ value: T,
  keyPaths: [PartialKeyPath<T.Element>] = [],
  /// The below three parameters are here so that they return the calling function, not *this* `printCollection` function
  file: String = #file,
  function: String = #function,
  line: Int = #line
) {
  
  let mirror = Mirror(reflecting: value)
  let typeName = String(describing: type(of: value))
  
  /// Header
  ///
  let fileAndLine = "File & Line: \t[\(URL(fileURLWithPath: file).lastPathComponent):\(line)]"
  let functionName = "Function: \t\(function)"
  let type = "Type: \t\t\(typeName)"
  
  let headerInfo = [fileAndLine, functionName, type].joined(separator: "\n")
  let formattedHeader = ConsoleOutput.header(headerInfo)
  
  /// Content
  ///
  
  var info = ""
  
  if !keyPaths.isEmpty && !mirror.children.isEmpty {
    info = value.prettyPrinted(keyPaths: keyPaths)
  } else {
    info = "Value: \(value)"
  }
  
  let finalLine = ConsoleOutput.footerLine
  
  /// Final output
  ///
  let finalOutput: String = """
  
  \(formattedHeader)
  
  \(info)
  
  \(finalLine)
  
  """
  
  print(finalOutput)
  
}



//public extension CustomStringConvertible {
//  var prettyString: String {
//    var output = ""
//    dump(self, to: &output)
//    return output
//  }
//}

struct ConsoleOutput {
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
  
  
  
  
  static let cornerTopLeft:       String = "┏"
  static let cornerTopRight:      String = "┓"
  
  static let cornerBottomLeft:    String = "┗"
  static let cornerBottomRight:   String = "┛"
  
  static let leftWallJoin:        String = "┠"
  
  static let rightWallJoin:       String = "┨"
  
  static let leftOrRightWall:     String = "┃"
  
  static let innerJoin:           String = "─"
  static let topAndBottom:        String = "━"
  
  
  
  static func draw(header: String, content: String, width: Int = 40) -> String {
    
    let headerLines = header.split(separator: "\n")
    let contentLines = content.split(separator: "\n")
    
    /// This `paddingSize` value compensates for:
    ///
    /// 1. The leading wall character
    /// 2. A leading space
    /// 3. An ellipsis or space character
    /// 4 A trailing space
    /// 5. The trailing wall character
    ///
    let paddingSize: Int = 5

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
      
      var paddingCharacter = spaceOrEllipsis(for: line, width: width, padding: paddingSize)
      
      
      let paddedLine = line.padding(
        toLength: width-paddingSize,
        withPad: " ",
        startingAt: 0
      )
      
      contentOnly += paddedLine
    }
    let content = "\(leftOrRightWall) \(contentOnly) \(leftOrRightWall)"
    
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
  
  static func spaceOrEllipsis(for content: Substring, width: Int, padding: Int) -> String {
    if content.count > width - padding {
      return "…"
    } else {
      return " "
    }
  }
}

struct BoxPrintView: View {
  
  var body: some View {
    
    VStack(spacing: 30) {
      VStack{
        Text("Width: 20")
        Text(ConsoleOutput.draw(
          header: "It's a long header, with more",
          content: TestStrings.paragraphs[1],
          width: 20
        ))
      }
      VStack{
        Text("Width: 40")
        Text(ConsoleOutput.draw(
          header: "It's a header",
          content: TestStrings.paragraphs[1],
          width: 40
        ))
      }
      VStack{
        Text("Width: 60")
        Text(ConsoleOutput.draw(
          header: "It's a header",
          content: TestStrings.paragraphs[1],
          width: 60
        ))
      }
    }
      .monospaced()
      .padding(40)
      .frame(width: 600, height: 700)
      .background(.black.opacity(0.6))
    
  }
}


#Preview {
  BoxPrintView()
}

