//
//  File.swift
//
//
//  Created by Dave Coleman on 11/7/2024.
//

import Foundation
import SwiftUI

extension Date {
  public enum Format {
    case date           // Monday, May 29 2025
    case dateAndTime    // Monday, May 29 2025 at 12:36pm
    case relative       // Yesterday, May 28 2025
  }
  
  public func format(_ style: Format) -> String {
    let dateFormatter = DateFormatter()
    
    switch style {
      case .date:
        dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
        return dateFormatter.string(from: self)
        
      case .dateAndTime:
        dateFormatter.dateFormat = "EEEE, MMMM d yyyy 'at' h:mma"
        /// Convert to lowercase 'am/pm'
        return dateFormatter.string(from: self).replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
        
      case .relative:
        /// Handle relative dates like "Today", "Yesterday"
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
          dateFormatter.dateFormat = "'Today', MMMM d yyyy"
          return dateFormatter.string(from: self)
        } else if calendar.isDateInYesterday(self) {
          dateFormatter.dateFormat = "'Yesterday', MMMM d yyyy"
          return dateFormatter.string(from: self)
        } else if calendar.isDateInTomorrow(self) {
          dateFormatter.dateFormat = "'Tomorrow', MMMM d yyyy"
          return dateFormatter.string(from: self)
        } else {
          dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
          return dateFormatter.string(from: self)
        }
    }
  }
}

#warning("The below could be revisited one day, when I have the energy. Got way too complicated and messy.")
//public struct FormatOptions {
//  var length: DateLength
//  var components: [DateComponents]
//  var seperator: Character
//  
//  public init(
//    length: DateLength = .medium,
//    components: [DateComponents] = [.time, .dayOfWeek],
//    seperator: Character = "–"
//  ) {
//    self.length = length
//    self.components = components
//    self.seperator = seperator
//  }
//  
//  public enum DateComponents {
//    case time
//    case dayOfWeek
//    case year
//  }
//  
//  public enum DateLength {
//    case short
//    case medium
//    case long
//    
//    var dayOfWeek: String {
//      switch self {
//        case .short:
//          "E"
//        case .medium:
//          "EEEE"
//        case .long:
//          "EEEE"
//      }
//    }
//    
//    var day: String {
//      switch self {
//        case .short:
//          "d"
//        case .medium:
//          "dd"
//        case .long:
//          "dd"
//      }
//    }
//    
//    var month: String {
//      switch self {
//        case .short:
//          "MMM"
//        case .medium:
//          "MMM"
//        case .long:
//          "MMMM"
//      }
//    }
//    
//    
//    var year: String {
//      switch self {
//        case .short, .medium, .long:
//          "yyyy"
//      }
//    }
//  }
//  
//}
//
//
//
//public extension Date {
//  
//  // Date Format Cheatsheet:
//  //
//  // Day of Week:
//  // Thu          E           (Short)
//  // Thursday     EEEE        (Full)
//  //
//  // Month:
//  // Jul          MMM         (Short)
//  // July         MMMM        (Full)
//  // 07           MM          (Number, padded)
//  // 7            M           (Number, not padded)
//  //
//  // Day of Month:
//  // 1            d           (Not padded)
//  // 01           dd          (Padded)
//  //
//  // Year:
//  // 2023         yyyy        (Full)
//  // 23           yy          (Short)
//  //
//  // Time:
//  // 1:34 PM      h:mm a      (12-hour)
//  // 13:34        HH:mm       (24-hour)
//  // 1:34:56 PM   h:mm:ss a   (With seconds, 12-hour)
//  // 13:34:56     HH:mm:ss    (With seconds, 24-hour)
//  //
//  // Examples:
//  // "EEEE, MMMM d, yyyy"           -> "Thursday, July 6, 2023"
//  // "E, MMM d, yy"                 -> "Thu, Jul 6, 23"
//  // "yyyy-MM-dd'T'HH:mm:ss"        -> "2023-07-06T13:34:56"
//  // "h:mm a 'on' MMMM d, yyyy"     -> "1:34 PM on July 6, 2023"
//  
//
//  /// Wednesday, 12 October, 2024
//  /// Wed, 12 October, 2024
//  /// 12 October, 2024
//  /// 12 Oct, 2024
//  ///
//  /// 12:54pm
//  ///
//
//  
//  
//  
//  
//  func quickFormat(_ options: FormatOptions) -> AttributedString {
//
//    let timeFormatter = DateFormatter()
//    let dateFormatter = DateFormatter()
//    
//    let time = options.components.contains(.time) ? "h:mma" : ""
//    let seperator = options.components.contains(.time) ? " \(options.seperator) " : ""
//    let dayOfWeek = options.components.contains(.dayOfWeek) ? "\(options.length.dayOfWeek), " : ""
//    let day = "\(options.length.day) "
//    let month = "\(options.length.month) "
//    let year = options.components.contains(.year) ? options.length.year : ""
//    
//    timeFormatter.dateFormat = time
//    dateFormatter.dateFormat = dayOfWeek + day + month + year
//    
//    let timeResult = timeFormatter.string(from: self).replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
//    let dateResult = dateFormatter.string(from: self)
//    
//    var attributedString = AttributedString(timeResult + seperator + dateResult)
//    attributedString.foregroundColor = .secondary.opacity(0.7)
//    
//    if let timeRange = attributedString.range(of: timeResult) {
//      attributedString[timeRange].foregroundColor = .primary.opacity(0.7)
//    }
//    
//    return attributedString
//  }
//  
//  /// Returns the date formatted as "Thu, July 11, 2024"
//  var mediumDateFormat: String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "E, MMMM d, yyyy"
//    return formatter.string(from: self)
//  }
//  
//  /// Returns the date and time formatted as "Thu, July 11, 2024 at 1:34pm"
//  var mediumDateTimeFormat: String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "E, MMMM d, yyyy 'at' h:mma"
//    return formatter.string(from: self).replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
//  }
//  
//  /// Returns the date and time formatted as "Updated: Just now" or "Updated: X minutes/hours ago" or "Today, 1:34pm", etc.
//  var friendlyDateAndTime: String {
////  var friendlyDateAndTime: AttributedString {
//    let now = Date()
//    let calendar = Calendar.current
//    let components = calendar.dateComponents([.day, .hour, .minute, .second], from: self, to: now)
//    
//    let formatter = DateFormatter()
//    formatter.locale = Locale.current
//    
//    var friendlyPart = ""
//    
//    if let seconds = components.second, let minutes = components.minute, let hours = components.hour, let days = components.day {
//      if seconds < 30 {
//        friendlyPart = "Just now, "
//        formatter.dateFormat = "h:mm:ss a"
//      } else if minutes == 0 {
//        friendlyPart = "Less than a minute ago "
//      } else if minutes < 60 {
//        friendlyPart = "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
//      } else if hours < 24 {
//        friendlyPart = "\(hours) hour\(hours == 1 ? "" : "s") ago"
//      } else if days == 0 {
//        friendlyPart = "Today, "
//        formatter.dateFormat = "h:mma"
//      } else if days == 1 {
//        friendlyPart = "Yesterday, "
//        formatter.dateFormat = "h:mma"
//      } else if days < 7 {
//        friendlyPart = "Last "
//        formatter.dateFormat = "EEEE"
//      } else if calendar.isDate(self, equalTo: now, toGranularity: .year) {
//        formatter.dateFormat = "EEEE, d MMMM"
//      } else {
//        formatter.dateFormat = "EEEE, d MMMM yyyy"
//      }
//    } else {
//      formatter.dateFormat = "EEEE, d MMMM yyyy"
//    }
//    
//    let datePart = formatter.string(from: self).replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
//    
//    var attributedString = AttributedString(friendlyPart)
//    attributedString += AttributedString(datePart)
//    
//    if !friendlyPart.isEmpty {
//      attributedString.foregroundColor = .secondary.opacity(0.7)
//      
//      if let dateRange = attributedString.range(of: datePart) {
//        attributedString[dateRange].foregroundColor = .primary.opacity(0.7)
//      }
//    } else {
//      attributedString.foregroundColor = .primary.opacity(0.7)
//    }
//    
//    return String(attributedString.characters)
//  }
//  
//  
//  /// Returns the date and time formatted as "1:34pm"
//  var mediumTimeFormat: String {
//    
//    let today = Date.now
//    var todayString: String = ""
//    
//    if today == self {
//      todayString = "Today at "
//    }
//    
//    let formatter = DateFormatter()
//    formatter.dateFormat = "\(todayString)h:mma"
//    return formatter.string(from: self).replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
//  }
//  
//  /// Returns the date formatted as "October 11 2024"
//  var shortDateFormat: String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMMM d yyyy"
//    return formatter.string(from: self)
//  }
//}
