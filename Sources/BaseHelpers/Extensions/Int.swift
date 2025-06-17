//
//  Int.swift
//  Helpers
//
//  Created by Dave Coleman on 23/8/2024.
//

import Foundation

extension Int {
  
  
  
  private static let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  public var formattedString: String {
    return Int.numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
  /// A Boolean value indicating whether the integer is even.
  public var isEven: Bool {
    self % 2 == 0
  }

  public var toString: String {
    String(self)
  }
//  
//  public var displayString: String {
//    String(self)
//  }

  public var asCGFloat: CGFloat {
    CGFloat(self)
  }

  public func isWithin(_ collection: some Collection) -> Bool {
    let startIndex = collection.startIndex
    let endIndex = collection.endIndex
    guard let index = collection.index(startIndex, offsetBy: self, limitedBy: endIndex) else {
      return false
    }
    return index < endIndex
  }

  public func isWithin(_ range: ClosedRange<Int>, isInclusive: Bool = true) -> Bool {
    guard isInclusive else {
      return self > range.lowerBound && self < range.upperBound
    }
    return self >= range.lowerBound && self <= (range.upperBound - 1)
  }

  public var columnType: NumberMagnitude {
    let absoluteValue = abs(self)

    switch absoluteValue {
      case 0..<10:
        return .ones
      case 10..<100:
        return .tens
      case 100..<1000:
        return .hundreds
      case 1000..<10000:
        return .thousands
      case 10000..<100000:
        return .tenThousands
      case 100000..<1_000_000:
        return .hundredThousands
      case 1_000_000..<1_000_000_000:
        return .millions
      default:
        return .billions
    }
  }

  public var numberOfDigits: Int {
    String(abs(self)).count
  }

}

extension Int64 {
  public func getString() -> String {
    String(self)
  }
}

public enum NumberMagnitude: String {
  case ones = "ones"
  case tens = "tens"
  case hundreds = "hundreds"
  case thousands = "thousands"
  case tenThousands = "ten thousands"
  case hundredThousands = "hundred thousands"
  case millions = "millions"
  case billions = "billions"

  public var columnCount: Int {
    switch self {
      case .ones: 1
      case .tens: 2
      case .hundreds: 3
      case .thousands: 4
      case .tenThousands: 5
      case .hundredThousands: 6
      case .millions: 7
      case .billions: 8
    }
  }
}
