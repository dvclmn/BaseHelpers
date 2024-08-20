//
//  Printing.swift
//  Utilities
//
//  Created by Dave Coleman on 20/8/2024.
//

import Foundation

public protocol Loggable {
  var loggableDescription: String { get }
}

extension Array: Loggable where Element: Loggable {
  public var loggableDescription: String {
    return "[\n" + map { "  " + $0.loggableDescription }.joined(separator: ",\n") + "\n]"
  }
}

// Extension for pretty printing
public extension CustomStringConvertible {
  var prettyPrinted: String {
    var output = ""
    dump(self, to: &output)
    return output
  }
}

public func logValue<T>(
  _ value: T,
  file: String = #file,
  function: String = #function,
  line: Int = #line
) {
  let mirror = Mirror(reflecting: value)
  let typeName = String(describing: type(of: value))
  
  print("[\(URL(fileURLWithPath: file).lastPathComponent):\(line)] \(function)")
  print("Type: \(typeName)")
  
  if let loggable = value as? Loggable {
    print("Value:")
    print(loggable.loggableDescription)
  } else if mirror.children.isEmpty {
    print("Value: \(value)")
  } else {
    print("Value:")
    print(String(describing: value).prettyPrinted)
  }
  print("") // Empty line for separation
}
