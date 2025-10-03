//
//  Model+ValueDisplay.swift
//  Components
//
//  Created by Dave Coleman on 21/12/2024.
//

import Foundation


//typealias MetricsRegex = Regex<(Substring, styleTarget: Substring)>
//
//struct Metrics: Equatable {
//
//  struct Item: Equatable, Identifiable {
//    let id: UUID
//    let label: String
//    let type: ValueType?
//    let category: Category
//    let value: AttributedString
//
//    init(
//      label: String,
//      type: ValueType? = nil,
//      category: Category = .general,
//      value: AttributedString
//    ) {
//      self.id = UUID()
//      self.label = label
//      self.type = type
//      self.category = category
//      self.value = value
//    }
//  }
//
//  enum ValueType {
//    case int
//    case cgFloat
//
//    var name: String {
//      switch self {
//        case .int:
//          "Int"
//        case .cgFloat:
//          "CGFloat"
//      }
//    }
//  }
//
//  enum Category: String, CaseIterable, Identifiable {
//    case general
//    case sidebar
//    case window
//    case grid
//
//    var id: String {
//      self.rawValue
//    }
//
//    var name: String {
//      self.rawValue.capitalized
//    }
//  }
//
//  var items: [Item]
//
//  init(items: [Item]) {
//    self.items = items
//  }
//}

extension Metrics {

  static func metricContent(_ attrString: AttributedString) -> AttributedString {
    var output = attrString

    let pattern: MetricsRegex = /(?<styleTarget>x|y|X|Y|:\s|,\s|W|H|Column|COL|Row|ROW|ROWS|COLS)/

    /// Get matches and their named captures
    let string = String(output.characters)
    let matches = string.matches(of: pattern)

    for match in matches {
      guard let range = output.range(of: match.output.styleTarget) else {
        break
      }
      output[range].setAttributes(style)
    }

    return output
  }

  private static var style: AttributeContainer {
    var container = AttributeContainer()

    container.backgroundColor = .clear
    container.foregroundColor = .secondary.opacity(0.6)
    container.font = .caption.weight(.medium)

    return container
  }
}
