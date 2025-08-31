//
//  Color+Hex.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import SwiftUI

extension Color {
  
  /// Create a `Color` instance from a hex string in SwiftUI.
  /// Supports the following formats:
  
  /// 1. 3-digit hex (RGB)
  /// 2. 6-digit hex (RGB)
  /// 3. 8-digit hex (ARGB)
  ///
  /// 6-digit hex (RGB)
  /// `let redColor = Color(hex: "FE6057")`
  ///
  /// 3-digit hex (RGB)
  /// `let blueColor = Color(hex: "00F")`
  ///
  /// 8-digit hex (ARGB)
  /// `let transparentGreen = Color(hex: "8000FF00")`
  public init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    
    let length = hexSanitized.count
    
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
    
    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
      
    } else if length == 8 {
      r = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000_FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x0000_00FF) / 255.0
      
    } else {
      return nil
    }
    self.init(red: r, green: g, blue: b, opacity: a)
  }
}
