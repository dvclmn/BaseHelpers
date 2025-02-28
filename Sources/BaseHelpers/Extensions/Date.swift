//
//  Date.swift
//  Collection
//
//  Created by Dave Coleman on 22/1/2025.
//

import Foundation

extension Date: @retroactive RawRepresentable {
  public var rawValue: String {
    self.timeIntervalSinceReferenceDate.description
  }

  public init?(rawValue: String) {
    self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
  }
}
/// ```
/// let formattedDate = DateFormatter.localizedString(
///   from: Date.minutesAgo(5),
///   dateStyle: .short,
///   timeStyle: .short
/// )
/// ```
extension Date {
  // MARK: - Ago Methods

  /// Returns a date `seconds` seconds ago from now.
  public func secondsAgo(_ seconds: TimeInterval) -> Date {
    return Date().addingTimeInterval(-seconds)
  }

  /// Returns a date `minutes` minutes ago from now.
  public func minutesAgo(_ minutes: TimeInterval) -> Date {
    return Date().addingTimeInterval(-minutes * 60)
  }

  /// Returns a date `hours` hours ago from now.
  public func hoursAgo(_ hours: TimeInterval) -> Date {
    return Date().addingTimeInterval(-hours * 3600)
  }

  /// Returns a date `days` days ago from now.
  public func daysAgo(_ days: TimeInterval) -> Date {
    return Date().addingTimeInterval(-days * 86400)
  }

  // MARK: - From Now Methods

  /// Returns a date `seconds` seconds from now.
  public func secondsFromNow(_ seconds: TimeInterval) -> Date {
    return Date().addingTimeInterval(seconds)
  }

  /// Returns a date `minutes` minutes from now.
  public func minutesFromNow(_ minutes: TimeInterval) -> Date {
    return Date().addingTimeInterval(minutes * 60)
  }

  /// Returns a date `hours` hours from now.
  public func hoursFromNow(_ hours: TimeInterval) -> Date {
    return Date().addingTimeInterval(hours * 3600)
  }

  /// Returns a date `days` days from now.
  public func daysFromNow(_ days: TimeInterval) -> Date {
    return Date().addingTimeInterval(days * 86400)
  }
}
