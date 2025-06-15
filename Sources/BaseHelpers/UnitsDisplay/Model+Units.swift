//
//  Model+Units.swift
//  Components
//
//  Created by Dave Coleman on 21/12/2024.
//

import Foundation

///
/// `points` e.g. `10.5 pts`, or `10.5 points`
/// `radians` e.g. `3.15 rad`
/// `hertz` e.g. `1,500 Hz`
/// `degrees` e.g. `45 deg` or `45°`
/// `normalised`
/// `percent` e.g. `15%`
/// `seconds` e.g. `2.0 sec` or `2.0 seconds`
/// `custom(String)`
///
public enum ValueUnits: Sendable, Equatable, Hashable {
  case decimal
  case points
  case radians
  case hertz
  case degrees
  case normalised(ClosedRange<Double>)
  case percent(ClosedRange<Double>)
  case seconds
  case custom(String)

  public var symbol: String {
    switch self {
      case .decimal: ""
      case .points: " pt"
      case .radians: " rad"
      case .hertz: " Hz"
      case .degrees: "°"
      case .normalised: ""
      case .percent: "%"
      case .seconds: " sec"
      case .custom(let customString): customString
    }
  }

  public var defaultConfiguration: ValueConfiguration {
    switch self {
      case .decimal, .points, .radians, .hertz, .degrees, .normalised, .custom:
        return .float
      case .percent, .seconds:
        return .wholeNumber
    }
  }

  /// Process the value according to unit type
  func processValue(_ value: Double) -> Double {
    switch self {
      case .decimal, .points, .radians, .hertz, .degrees, .seconds, .custom:
        return value

      case .normalised(let range):
        // Normalise to 0...1
//        guard let range else {
//          return 0
//        }
        return ((value - range.lowerBound) / (range.upperBound - range.lowerBound))
          .clamped(to: 0...1)

      case .percent(let range):
//        guard let range else {
//          return 0
//        }
        /// Normalise and convert to percentage (0-100)
        let normalised = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (normalised * 100).clamped(to: 0...100)
    }
  }

  /// Format the processed value according to configuration
  func formatValue(
    _ value: Double,
    configuration: ValueConfiguration
  ) -> AttributedString {
    let formatter = NumberFormatter()

    /// Basic configuration
    formatter.usesGroupingSeparator = configuration.usesDigitGrouping
    formatter.minimumIntegerDigits = configuration.integerDigits
    
    /// Allow large numbers if needed
    formatter.maximumIntegerDigits = configuration.integerDigits > 0 ? 100 : 0
    formatter.minimumFractionDigits = configuration.fractionalDigits
    formatter.maximumFractionDigits = configuration.fractionalDigits
    formatter.roundingMode = .halfUp

    
    /// Handle percent formatting specially
    if case .percent = self {
      formatter.numberStyle = .percent
      formatter.multiplier = 1  // Value is already 0-100
    } else {
      formatter.numberStyle = .decimal
    }

    // Handle polarity sign
    if configuration.includePolaritySign {
      formatter.positivePrefix = "+"
    }

    // Format the value
    let number = NSNumber(value: value)
    var formattedString = formatter.string(from: number) ?? "\(value)"

    // Add unit symbol if not percent (which is already handled by formatter)
    if self != .percent {
      formattedString += symbol
    }

    let leadingZeroPattern: Regex<Substring> = /^0+(?=\d)/

    var attributedString = AttributedString(formattedString)
    let matches = formattedString.matches(of: leadingZeroPattern)

    for match in matches {
      guard let range = attributedString.range(of: match.output) else {
        break
      }
      attributedString[range].setAttributes(.invisible)
    }

    return attributedString
  }
}
