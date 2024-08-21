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


//@resultBuilder
//struct PrintWrapperBuilder {
//  static func buildBlock(_ components: Any...) -> [Any] {
//    return components
//  }
//}
//
//func printWrapper(
//  diagnostics: DiagnosticInformation = .init(),
//  @PrintWrapperBuilder content: () -> [Any]
//) {
//  let header: String = formatPrintHeader(diagnostics: diagnostics)
//  let footer: String = ConsoleOutput.line
//  
//  print(header)
//  print("")
//  for component in content() {
//    print(component)
//  }
//  print("")
//  print(footer)
//}




public func printWrapper(
  diagnostics: DiagnosticInformation = .init(),
  function: () -> Void
) {
  
  let header: String = formatPrintHeader(diagnostics: diagnostics)
  let footer: String = ConsoleOutput.line
  
  print(header)
  print("")
  function()
  print("")
  print(footer)
  
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

func formatPrintHeader(
  title: String? = nil,
  value: Any? = nil,
  diagnostics: DiagnosticInformation
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

func formatPrintInfo(
  _ title: String? = nil,
  value: Any,
  diagnostics: DiagnosticInformation,
  hasTrailingLine: Bool = true
) -> String {
  
  let header = formatPrintHeader(
    title: title,
    value: value,
    diagnostics: diagnostics
  )

  let finalLine = hasTrailingLine ? ConsoleOutput.line : ""
  
  let output: String = """
  
  \(header)
  
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
