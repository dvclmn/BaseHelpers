//
//  AttributedString.swift
//  TextCore
//
//  Created by Dave Coleman on 31/8/2024.
//

import SwiftUI

extension AttributedString {

  public func index(at offset: Int) -> AttributedString.Index? {
    guard offset >= 0 && offset <= characters.count else {
      return nil
    }
    return index(startIndex, offsetByCharacters: offset)
  }

  ///
  /// ```
  /// var output = attrString
  ///
  /// let numberByNumberPattern: Regex.TripleCapture = /([\d\.]+)(x)([\d\.]+)/
  ///
  /// if let ranges = getRange(for: numberByNumberPattern, in: output) {
  ///   output[ranges.0].setAttributes(style(for: part, subPart: .number))
  ///   output[ranges.1].setAttributes(style(for: part, subPart: .operator))
  ///   output[ranges.2].setAttributes(style(for: part, subPart: .number))
  /// }
  ///
  /// return output
  /// ```

  public mutating func quickHighlight() {

    print(self.toString)

    let highlightContainer: AttributeContainer = .highlighter
    self.setAttributes(highlightContainer)
  }
  
  public var toString: String {
    String(self.characters)
  }

  public func lines(
    subsequenceStrategy: SubsequenceStrategy = .doNotOmit
  ) -> [String] {
    return self.toString.lines(subsequenceStrategy: subsequenceStrategy)
  }

  public var lines: [String] {
    self.lines(subsequenceStrategy: .doNotOmit)
  }

  public mutating func append(
    _ string: String,
    addsLineBreak: Bool
  ) {
    self.characters.append(contentsOf: addsLineBreak ? "\(string)\n" : "\(string)")
  }

  public mutating func append(
    _ character: Character,
    addsLineBreak: Bool
  ) {
    self.characters.append(contentsOf: addsLineBreak ? "\(character)\n" : "\(character)")
  }

  public mutating func addLineBreak() {
    self.characters.append("\n")
  }

}
