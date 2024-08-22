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
