//
//  PrettyPrinting.swift
//  Helpers
//
//  Created by Dave Coleman on 20/8/2024.
//

import Foundation

/// #Example usage:
///
/// ```swift
/// struct Person: Encodable {
///   let name: String
///   let age: Int
/// }
///
/// let people = [
///   Person(name: "Alice", age: 30),
///   Person(name: "Bob", age: 25),
///   Person(name: "Charlie", age: 35)
/// ]
///
/// // Using default (all properties)
/// print(people.prettyPrinted())
///
/// // Specifying specific properties
/// print(people.prettyPrinted(keyPaths: [\.name]))
/// ```
///
/// This will output:
///
/// ```
/// [
///   name: Alice, age: 30,
///   name: Bob, age: 25,
///   name: Charlie, age: 35,
/// ]
///
/// [
///   name: Alice,
///   name: Bob,
///   name: Charlie,
/// ]
/// ```
///
//public extension Collection {
//  func prettyPrinted(keyPaths: [PartialKeyPath<Element>]? = nil) -> String {
//    let mirror = Mirror(reflecting: Element.self)
//    let defaultKeyPaths: [PartialKeyPath<Element>] = mirror.children.compactMap { child in
//      guard let label = child.label else { return nil }
//      return Mirror(reflecting: \Element.self).children
//        .first { $0.label == label }?
//        .value as? PartialKeyPath<Element>
//    }
//
//    let useKeyPaths = keyPaths ?? defaultKeyPaths
//
//    var result = "[\n"
//    for element in self {
//      let values = useKeyPaths.map { keyPath in
//        let value = element[keyPath: keyPath]
//        let label = String(describing: keyPath).split(separator: ".").last ?? ""
//        return "\(label): \(value)"
//      }.joined(separator: ", ")
//      result += "    \(values),\n"
//    }
//    result += "]"
//    return result
//  }
//}

/// To use this one, I have to explicitly pass the keypaths that I want to see in the output
///


//
//public extension Collection {
//  func prettyPrinted(keyPaths: [PartialKeyPath<Element>]) -> String {
//    var result = "[\n"
//    for element in self {
//      let values = keyPaths.map { keyPath in
//        let value = element[keyPath: keyPath]
//        let label = String(describing: keyPath).split(separator: ".").last ?? ""
//        return "\(label): \(value)"
//      }.joined(separator: ", ")
//      result += "    \(values),\n"
//    }
//    result += "]"
//    return result
//  }
//}

public extension Collection {
  func prettyPrinted(keyPaths: [PartialKeyPath<Element>], indent: String = "  ") -> String {
    func formatValue<T>(_ value: T, depth: Int) -> String {
      let nextIndent = String(repeating: indent, count: depth + 1)
      
      func formatCollection<C: Collection>(_ collection: C) -> String {
        if collection.isEmpty {
          return "[]"
        }
        var result = "[\n"
        for (index, item) in collection.enumerated() {
          result += "\(nextIndent)// \(index + 1)\n"
          result += "\(nextIndent)\(formatValue(item, depth: depth + 1)),\n"
        }
        result += "\(String(repeating: indent, count: depth))]"
        return result
      }
      
      if let collection = value as? any Collection {
        return formatCollection(collection)
      } else if let describable = value as? CustomStringConvertible {
        let description = describable.description
        if description.contains("(") && description.contains(")") {
          let components = description.components(separatedBy: "(")
          let name = components[0]
          let params = components[1].dropLast()
          let paramPairs = params.components(separatedBy: ",")
          
          var result = "\(name)(\n"
          for param in paramPairs {
            result += "\(nextIndent)\(param.trimmingCharacters(in: .whitespaces)),\n"
          }
          result += "\(String(repeating: indent, count: depth)))"
          return result
        }
      }
      
      return String(describing: value)
    }
    
    var result = "[\n"
    for (index, element) in self.enumerated() {
      result += "\(indent)// \(index + 1)\n"
      for keyPath in keyPaths {
        let value = element[keyPath: keyPath]
        let label = String(describing: keyPath).split(separator: ".").last ?? ""
        result += "\(indent)\(label): \(formatValue(value, depth: 1)),\n"
      }
      result += "\n"
    }
    result += "]"
    return result
  }
}



public extension Collection where Element == (key: String, value: Int) {
  func prettyPrinted(
    delimiter: String = ".",
    keyFirst: Bool = true,
    stripCharacters: Bool = false
  ) -> String {
    var result = "Headers:\n\n"
    for element in self {
      let key = stripCharacters ? element.key.filter { !$0.isWhitespace && $0.isLetter } : element.key
      let value = element.value
      if keyFirst {
        result += "\(value)\(delimiter) \"\(key)\"\n"
      } else {
        result += "\"\(key)\"\(delimiter) \(value)\n"
      }
    }
    return result
  }
}

//public extension Regex<AnyRegexOutput.RegexOutput>.Match {
//  var prettyDescription: String {
//    var result = "Match:\n"
//    result += "  Range: \(self.range)\n"
//    result += "  Matched text: \"\(self.0)\"\n"
//
//    let mirror = Mirror(reflecting: self.output)
//    let captureGroups = mirror.children.dropFirst() // Skip the full match
//
//    if !captureGroups.isEmpty {
//      result += "  Captured groups:\n"
//      for (index, capture) in captureGroups.enumerated() {
//        if let value = capture.value as? Substring, !value.isEmpty {
//          result += "    Group \(index + 1): \"\(value)\"\n"
//        }
//      }
//    }
//
//    result += "  Output:\n"
//    result += "    Full match: \"\(self.output.0)\"\n"
//
//    for (index, capture) in captureGroups.enumerated() {
//      if let value = capture.value as? Substring {
//        result += "    Capture \(index + 1): \"\(value)\"\n"
//      }
//    }
//
//    return result
//  }
//}


public extension Regex<Regex<(
  Substring,
  leading: Substring,
  content: Substring,
  trailing: Substring
)>.RegexOutput>.Match {
  
  var prettyDescription: String {
    
    
      var result = "Match:\n"
      result += "  Range: \(self.range)\n"
      result += "  Matched text: \"\(self.0)\"\n"
      result += "  Output:\n"
      result += "    Full match: \"\(self.0)\"\n"
      result += "    Leading: \"\(self.leading)\"\n"
      result += "    Content: \"\(self.content)\"\n"
      result += "    Trailing: \"\(self.trailing)\"\n"
      return result
    
  
    
  }
  
  func boxedDescription(header: String) -> String {
    return ConsoleOutput.draw(
      header: header,
      content: self.prettyDescription
    )
  }
}

public extension Regex<Regex<(Substring, Substring)>.RegexOutput>.Match {
  
  var prettyDescription: String {
    var result = "Match:\n"
    result += "  Range: \(self.range)\n"
    result += "  Matched text: \"\(self.0)\"\n"
    
    if !self.1.isEmpty {
      result += "  Captured group: \"\(self.1)\"\n"
    }
    
    result += "  Output:\n"
    result += "    Full match: \"\(self.output.0)\"\n"
    result += "    Capture: \"\(self.output.1)\"\n"
    return result
  }
  
  func boxedDescription(header: String) -> String {
    return ConsoleOutput.draw(header: header, content: self.prettyDescription)
  }
  
  
}

public extension Regex<Regex<Substring>.RegexOutput>.Match {
  var prettyDescription: String {
    var result = "Match:\n"
    result += "  Range: \(self.range)\n"
    result += "  Matched text: \"\(self)\"\n"
    
    result += "  Output:\n"
    result += "  Full match: \"\(self.output)\"\n"
    return result
  }
}
