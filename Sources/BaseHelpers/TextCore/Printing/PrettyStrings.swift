//
//  PrettyPrinting.swift
//  Helpers
//
//  Created by Dave Coleman on 20/8/2024.
//

import Foundation

public struct PrettyPrint<Value: CustomStringConvertible> {
  let value: Value
  let maxDepth: Int

  private var indent: Int = 0
  private var currentDepth: Int = 0

  

  public init(
    _ value: Value,
    maxDepth: Int = 3,
  ) {
    self.value = value
    self.maxDepth = maxDepth
  }
}

extension PrettyPrint {
  
  private var indentation: String {
    String(repeating: " ", count: self.indent)
  }
  private var nestedIndentationation: String {
    String(repeating: " ", count: self.indent + 2)
  }

  public var prettyPrinted: String {

    //    if let printable = value as? DirectlyPrintable {
    //      return printable.printableString
    //    }

    switch value {
      case let array as [Value]:
        return arrayString(array)

      case let dict as [AnyHashable: Any]:
        if dict.isEmpty { return "[:]" }

        // If we're at max depth, truncate the dictionary
        if currentDepth >= maxDepth {
          return "{...}"
        }

        let maxKeyLength =
          dict.keys.map {
            prettyPrintValue($0, indent: 0, currentDepth: currentDepth, maxDepth: maxDepth).count
          }.max() ?? 0

        var result = "[\n"
        for (key, value) in dict {
          let keyString = prettyPrintValue(key, indent: indent + 2, currentDepth: currentDepth, maxDepth: maxDepth)

          // For nested structures at maxDepth, show {...}
          let valueString: String
          if shouldTruncateValue(value) && currentDepth + 1 >= maxDepth {
            valueString = "{...}"
          } else {
            valueString = prettyPrintValue(
              value, indent: indent + 2, currentDepth: currentDepth + 1, maxDepth: maxDepth)
          }

          let padding = max(0, maxKeyLength - keyString.count + 1)
          result += "\(nestedIndentation)\(keyString):\(String(repeating: " ", count: padding))\(valueString),\n"
        }
        result = String(result.dropLast(2))
        result += "\n\(indentation)]"
        return result

      default:
        let mirror = Mirror(reflecting: value)
        if mirror.children.isEmpty {
          return String(describing: value)
        }

        // If we're at max depth, truncate the object
        if currentDepth >= maxDepth {
          return "{...}"
        }

        let padding = calculatePadding(for: mirror.children)

        var result = "{\n"
        for child in mirror.children {
          if let label = child.label {
            let key = "\"\(label)\""
            let spaces = String(repeating: " ", count: max(0, padding - key.count))

            // For nested structures at maxDepth, show {...}
            let valueString: String
            if shouldTruncateValue(child.value) && currentDepth + 1 >= maxDepth {
              valueString = "{...}"
            } else {
              valueString = prettyPrintValue(
                child.value, indent: indent + 2, currentDepth: currentDepth + 1, maxDepth: maxDepth)
            }

            result += "\(nestedIndentation)\(key):\(spaces)\(valueString),\n"
          }
        }
        result = String(result.dropLast(2))
        result += "\n\(indentation)}"
        return result
    }
  }

  private func arrayString(_ array: [Value]) -> String {
    if array.isEmpty { return "[]" }

    /// If at max depth, truncate the array
    if currentDepth >= maxDepth {
      return "[...]"
    }

    var result = "[\n"
    for element in array {
      result +=
        "\(nestedIndentation)\(prettyPrintValue(element, indent: indent + 2, currentDepth: currentDepth + 1, maxDepth: maxDepth)),\n"
    }
    result = String(result.dropLast(2))
    result += "\n\(indentation)]"
    return result

  }

  private func calculateIndentation(_ indentCharacter: String?) -> Int {

  }
}

//public extension Array {
//  var prettyPrinted: String {
//    prettyPrintValue(self, indent: 0, currentDepth: 0, maxDepth: 2)
//  }
//
//  func prettyPrinted(maxDepth: Int = .max) -> String {
//    prettyPrintValue(self, indent: 0, currentDepth: 0, maxDepth: maxDepth)
//  }
//}

//public extension Dictionary {
//  var prettyPrinted: String {
//    prettyPrintValue(self, indent: 0, currentDepth: 0, maxDepth: 2)
//  }
//
//  func prettyPrinted(maxDepth: Int = .max) -> String {
//    prettyPrintValue(self, indent: 0, currentDepth: 0, maxDepth: maxDepth)
//  }
//}

private func calculatePadding(for children: Mirror.Children) -> Int {
  /// Find the longest key length including quotes
  let maxLength = children.compactMap { $0.label }.map { $0.count + 2 }.max() ?? 0
  return maxLength + 1  // Add 1 for the colon
}

// Protocol for types that can be directly printed
//private protocol DirectlyPrintable {
//  var printableString: String { get }
//}
//
//// Extend basic types to conform to DirectlyPrintable
//extension String: DirectlyPrintable {
//  var printableString: String { "\"\(self.replacingOccurrences(of: "\"", with: "\\\""))\"" }
//}
//
//extension Numeric where Self: CustomStringConvertible {
//  var printableString: String { description }
//}
//extension Int: DirectlyPrintable {}
//extension Double: DirectlyPrintable {}
//extension Float: DirectlyPrintable {}
//
//extension Bool: DirectlyPrintable {
//  var printableString: String { description }
//}
//
//extension Date: DirectlyPrintable {
//  var printableString: String { "\"\(ISO8601DateFormatter().string(from: self))\"" }
//}
//
//extension URL: DirectlyPrintable {
//  var printableString: String { "\"\(absoluteString)\"" }
//}
//
//extension Data: DirectlyPrintable {
//  var printableString: String { "\"\(base64EncodedString())\"" }
//}

// Helper function to determine if a value should be truncated
//private func shouldTruncateValue(_ value: Any) -> Bool {
//  if value is DirectlyPrintable { return false }
//
//  switch value {
//    case is [Any], is [AnyHashable: Any]:
//      return true
//    default:
//      let mirror = Mirror(reflecting: value)
//      return !mirror.children.isEmpty
//  }
//}

