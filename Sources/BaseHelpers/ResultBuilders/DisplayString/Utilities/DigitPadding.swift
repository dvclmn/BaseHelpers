//
//  DigitPadding.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

public struct DigitPadding {

  public let value: Int

  /// How much to pad the value, if required.
  /// E.g. if `value` is `20`, and `targetWidth`
  /// is `3`, then the output would be:
  /// `{space}20`. For `value = 3`, the output
  /// would be `{space}{space}3`.
  public let targetWidth: Int
  public let paddingCharacter: Character

  public init(
    _ value: Int,
    targetWidth: Int = 3,
    paddingCharacter: Character = " "
  ) {
    self.value = value
    self.targetWidth = targetWidth
    self.paddingCharacter = paddingCharacter
  }

  /// Returns the padded string representation of the value
  public func paddedString() -> String {
    let valueString = String(value)
    let currentWidth = valueString.count

    if currentWidth >= targetWidth {
      return valueString
    }

    let paddingNeeded = targetWidth - currentWidth
    let padding = String(repeating: paddingCharacter, count: paddingNeeded)

    return padding + valueString
  }

  /// Alternative implementation using String's padding method
  public func paddedStringBuiltIn() -> String {
    return String(value)
      .padding(
        toLength: targetWidth,
        withPad: String(paddingCharacter),
        startingAt: 0)
  }
}

// MARK: - String Representation
extension DigitPadding: CustomStringConvertible {
  public var description: String {
    return paddedString()
  }
}

// MARK: - Usage Examples

/// ```
/// let padding1 = DigitPadding(20, targetWidth: 3)
/// print("'\(padding1.paddedString())'") // ' 20'
///
/// let padding2 = DigitPadding(3, targetWidth: 3)
/// print("'\(padding2.paddedString())'") // '  3'
///
/// let padding3 = DigitPadding(1234, targetWidth: 3)
/// print("'\(padding3.paddedString())'") // '1234' (no padding needed)
///
/// let padding4 = DigitPadding(5, targetWidth: 4, paddingCharacter: "0")
/// print("'\(padding4.paddedString())'") // '0005'
///
/// // Using CustomStringConvertible
/// let padding5 = DigitPadding(42, targetWidth: 5, paddingCharacter: "*")
/// print("'\(padding5)'") // '***42'
/// ```
