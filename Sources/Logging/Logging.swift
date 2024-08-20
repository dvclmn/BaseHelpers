//
//  Logging.swift
//  Utilities
//
//  Created by Dave Coleman on 20/8/2024.
//

import Foundation
import BaseHelpers


/// # Usage examples
///
/// ```
/// coloredPrint("This is a red message", color: .red)
/// coloredPrint("This is a green message", color: .green)
/// coloredPrint("This is a blue message", color: .blue)
///
/// formattedPrint("This is bold red text on a yellow background", textColor: .red, backgroundColor: .bgYellow, formatting: .bold)
///
/// logInfo("This is an informational message")
/// logWarning("This is a warning message")
/// logError("This is an error message")
/// logSuccess("This operation completed successfully")
/// logDebug("Here's some debug information")
///
/// Logger.log("Starting operation", level: .info)
/// Logger.log("Operation completed", level: .success)
/// Logger.log("An error occurred", level: .error)
///
/// ```

public enum LogLevel: String {
  case debug, info, warning, error, success
}

public class Logger {
  
  /// Note: The items beginning with a `#` below are special symbols in Swift, called
  /// "literal expressions" or "magic literals." These are special compiler directives
  /// that provide information about the current source code context.
  ///
  /// They expanded into the results you'd expect; `#file` will return the name of the current
  /// that the code is in, `#function` returns the name of the function, and so on.
  ///
  public static func log(
    _ items: Any...,
    level: LogLevel = .info,
    file: String = #file,
    function: String = #function,
    line: Int = #line
  ) {
    let filename = URL(fileURLWithPath: file).lastPathComponent
    let prefix: String
    let color: ANSIColors
    
    switch level {
      case .debug:
        prefix = "🔍 DEBUG"
        color = .cyan
      case .info:
        prefix = "ℹ️ INFO"
        color = .blue
      case .warning:
        prefix = "⚠️ WARNING"
        color = .yellow
      case .error:
        prefix = "🚫 ERROR"
        color = .red
      case .success:
        prefix = "✅ SUCCESS"
        color = .green
    }
    
    let message = items.map { String(describing: $0) }.joined(separator: " ")
    formattedPrint("\(prefix) [\(filename):\(line)] \(function):", terminator: " ", textColor: color)
    print(message)
  }
}

public func coloredPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", color: ANSIColors) {
  let output = items.map { "\(color.rawValue)\($0)\(ANSIColors.reset.rawValue)" }.joined(separator: separator)
  print(output, terminator: terminator)
}

public func formattedPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", textColor: ANSIColors? = nil, backgroundColor: ANSIColors? = nil, formatting: ANSIColors? = nil) {
  var formatString = ""
  if let textColor = textColor { formatString += textColor.rawValue }
  if let backgroundColor = backgroundColor { formatString += backgroundColor.rawValue }
  if let formatting = formatting { formatString += formatting.rawValue }
  
  let output = items.map { "\(formatString)\($0)\(ANSIColors.reset.rawValue)" }.joined(separator: separator)
  print(output, terminator: terminator)
}

//public func logInfo(_ items: Any...) {
//  formattedPrint("ℹ️ INFO:", terminator: " ")
//  formattedPrint(items, textColor: .blue)
//}
//
//public func logWarning(_ items: Any...) {
//  formattedPrint("⚠️ WARNING:", terminator: " ")
//  formattedPrint(items, textColor: .yellow)
//}
//
//public func logError(_ items: Any...) {
//  formattedPrint("🚫 ERROR:", terminator: " ")
//  formattedPrint(items, textColor: .red)
//}
//
//public func logSuccess(_ items: Any...) {
//  formattedPrint("✅ SUCCESS:", terminator: " ")
//  formattedPrint(items, textColor: .green)
//}
//
//public func logDebug(_ items: Any...) {
//  formattedPrint("🔍 DEBUG:", terminator: " ")
//  formattedPrint(items, textColor: .cyan)
//}
