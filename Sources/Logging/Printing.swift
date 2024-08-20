//
//  Printing.swift
//  Utilities
//
//  Created by Dave Coleman on 20/8/2024.
//

import Foundation
import BaseHelpers


public func printValue<T: Collection>(
  _ value: T,
  keyPaths: [PartialKeyPath<T.Element>] = [],
  /// The below three parameters are here so that they return the calling function, not *this* `printValue` function
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
