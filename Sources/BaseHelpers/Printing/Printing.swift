//
//  Printing.swift
//  Helpers
//
//  Created by Dave Coleman on 21/8/2024.
//

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
  diagnostics: DiagnosticInformation = .init()
) {
  
  var valueString = "Value: \(value)"

  let output = formatPrintInfo("Title here", value: valueString, diagnostics: diagnostics)
  
  print(output)
}

func formatPrintInfo(
  _ title: String? = nil,
  value: String,
  diagnostics: DiagnosticInformation
) -> String {
  
  let mirror = Mirror(reflecting: value)
  let typeName = String(describing: type(of: value))
  
  /// Header
  ///
  let fileAndLine = "File & Line: \t[\(URL(fileURLWithPath: diagnostics.fileName).lastPathComponent):\(diagnostics.line)]"
  let functionName = "Function: \t\(diagnostics.functionName)"
  let type = "Type: \t\t\(typeName)"
  
  let headerInfo = [(title ?? ""), fileAndLine, functionName, type].joined(separator: "\n")
  let formattedHeader = ConsoleOutput.header(headerInfo)
  let finalLine = ConsoleOutput.line
  
  let output: String = """
  
  \(formattedHeader)
  
  \(value)
  
  \(finalLine)
  
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
  
  let finalLine = ConsoleOutput.line
  
  /// Final output
  ///
  let finalOutput: String = """
  
  \(formattedHeader)
  
  \(info)
  
  \(finalLine)
  
  """
  
  print(finalOutput)
  
}



public extension CustomStringConvertible {
  var prettyString: String {
    var output = ""
    dump(self, to: &output)
    return output
  }
}

struct ConsoleOutput {
  static func header(_ info: String) -> String {
    return """
    
    \(line)
    \(info)
    \(line)
    """
  }
  
  
  static let line: String = "---------------------------------------------------------"
}
