//
//  MultiPlatform.swift
//  Collection
//
//  Created by Dave Coleman on 14/11/2024.
//


#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Platform-specific type aliases
#if canImport(UIKit)
public typealias OColor = UIColor
public typealias OFont = UIFont
public typealias OImage = UIImage
public typealias OView = UIView
public typealias OViewController = UIViewController
public typealias OBezierPath = UIBezierPath
public typealias OScreen = UIScreen
public typealias OEvent = UIEvent

#elseif canImport(AppKit)
public typealias OColor = NSColor
public typealias OFont = NSFont
public typealias OImage = NSImage
public typealias OView = NSView
public typealias OViewController = NSViewController
public typealias OBezierPath = NSBezierPath
public typealias OScreen = NSScreen
public typealias OEvent = NSEvent

#endif

/// Something I learned — not all `NS`-prefixed types are AppKit-only!
///
/// Examples of cross-platform `NS` types:
///
/// `NSAttributedString`
/// `NSMutableAttributedString`
/// `NSString`
/// `NSArray`, `NSDictionary`, `NSSet`
/// `NSDate`
/// `NSNumber`
/// `NSData`
/// `NSCache`
/// `NSURLSession`
/// `NSNotification` / `NSNotificationCenter`


// MARK: - Platform-specific constants
public enum OConstants {
#if canImport(UIKit)
  static let isIOS = true
  static let isMacOS = false
#elseif canImport(AppKit)
  static let isIOS = false
  static let isMacOS = true
#endif
}
