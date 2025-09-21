//
//  Searchable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

public final class ExampleFuzzySearchProvider: FuzzyProvider {
  public func searchSync(_ text: String, in aString: String) -> ScoredRanges? {
    fatalError("No implementation")
  }

}

extension DummyContent {
  public enum SearchableItem: String, FuzzySearchable, CaseIterable, Cyclable, LabeledItem, Pickable {

    public typealias Provider = ExampleFuzzySearchProvider
    public static let defaultCase: Self = .ratio
    public static let pickerLabel: QuickLabel = QuickLabel("Cool Item")

    case ratio
    case fraction
    case unitPoint
    case price
    case sizes

    public var id: String { name }
    public var name: String {
      switch self {
        case .ratio: "Ratio Calculator"
        case .fraction: "Fraction Simplifier Long Title"
        case .price, .sizes: rawValue.capitalized
        case .unitPoint: "UnitPoint Visualiser"
      }
    }

    /// For Search lookup
    public var stringRepresentation: String { name }

    public func fuzzyMatch(
      using provider: Provider,
      query: String
    ) -> FuzzyMatch<Self>? {
      guard let result = provider.searchSync(query, in: name) else { return nil }
      return FuzzyMatch(item: self, score: result.score, ranges: result.ranges)
    }

    public var label: QuickLabel {
      QuickLabel(self.name, self.icon)
    }

    public var icon: String {
      switch self {
        case .ratio: "aspectratio"
        case .fraction: "chart.pie"
        case .unitPoint: "circle.grid.3x3"  // circle.grid.2x2, dot.circle.and.cursorarrow, smallcircle.filled.circle
        case .price: "dollarsign"  // cart
        case .sizes: "chart.bar.xaxis.ascending"
      }
    }

    public var blurb: String {
      switch self {
        default:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate"

      }
    }

    func isSelected(_ currentState: Self) -> Bool {
      self == currentState
    }
  }
}
