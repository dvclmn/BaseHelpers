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



public extension Collection {
  func prettyPrinted(keyPaths: [PartialKeyPath<Element>]) -> String {
    var result = "[\n"
    for element in self {
      let values = keyPaths.map { keyPath in
        let value = element[keyPath: keyPath]
        let label = String(describing: keyPath).split(separator: ".").last ?? ""
        return "\(label): \(value)"
      }.joined(separator: ", ")
      result += "    \(values),\n"
    }
    result += "]"
    return result
  }
}

//
//
//public extension Collection {
//  func prettyPrinted<T>(keyPaths: [KeyPath<Element, T>]) -> String {
//    var result = "[\n"
//    for element in self {
//      let values = keyPaths.map { keyPath in
//        return "\(element[keyPath: keyPath])"
//      }.joined(separator: ", ")
//      result += "    \(values),\n"
//    }
//    result += "]"
//    return result
//  }
//}





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
