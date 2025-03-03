//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI
import NSUI

//extension Color {
//  public func blend(with other: Color, percentage: Double) -> Color {
//    Color(nsColor: NSUIColor(self).blend(with: NSUIColor(other), percentage: percentage))
//  }
//}
//
//extension NSUIColor {
//  public func blend(with other: NSUIColor, percentage: Double) -> NSUIColor {
//    let percentage = max(min(percentage, 1), 0)
//    switch percentage {
//      case 0: return self
//      case 1: return other
//      default:
//        guard
//          let selfRGB = self.usingColorSpace(.sRGB),
//          let otherRGB = other.usingColorSpace(.sRGB)
//        else { return self }
//        
//        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
//        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
//        
//        selfRGB.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
//        otherRGB.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
//        
//        return NSColor(
//          red: r1 + (r2 - r1) * percentage,
//          green: g1 + (g2 - g1) * percentage,
//          blue: b1 + (b2 - b1) * percentage,
//          alpha: a1 + (a2 - a1) * percentage
//        )
//    }
//  }
//}
//

/// This extension allows you to create a `Color` instance from a hex string in SwiftUI. It supports the following formats:

/// 1. 3-digit hex (RGB)
/// 2. 6-digit hex (RGB)
/// 3. 8-digit hex (ARGB)
///
/// // 6-digit hex (RGB)
/// let redColor = Color(hex: "FE6057")
///
/// // 3-digit hex (RGB)
/// let blueColor = Color(hex: "00F")
///
/// // 8-digit hex (ARGB)
/// let transparentGreen = Color(hex: "8000FF00")
///
/// // In a SwiftUI View
/// struct ContentView: View {
///     var body: some View {
///         VStack {
///             Rectangle()
///                 .fill(Color(hex: "FE6057"))
///                 .frame(width: 100, height: 100)
///
///             Text("Hello, World!")
///                 .foregroundColor(Color(hex: "00F"))
///         }
///     }
/// }

//#if canImport(AppKit)
//
//import AppKit

public extension Color {
  var nsColour: NSUIColor {
    NSUIColor(self)
  }
}

//#endif

public extension Color {
  
  static func random(randomOpacity: Bool = false) -> Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      opacity: randomOpacity ? .random(in: 0...1) : 1
    )
  }
  
  
  
}


// MARK: - Random colour
public extension ShapeStyle where Self == Color {
  static var random: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
  static var fadedBlack: Color {
    .black.opacity(0.2)
  }
  static var fadedBlackDarker: Color {
    .black.opacity(0.4)
  }
  
}



public extension Color {
  
  init?(hex: String) {
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
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
      
    } else {
      return nil
    }
    
    self.init(red: r, green: g, blue: b, opacity: a)
  }
  
//  init(hex: String) {
//    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//    var int: UInt64 = 0
//    Scanner(string: hex).scanHexInt64(&int)
//    let a, r, g, b: UInt64
//    switch hex.count {
//      case 3: // RGB (12-bit)
//        (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//      case 6: // RGB (24-bit)
//        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//      case 8: // ARGB (32-bit)
//        (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//      default:
//        (a, r, g, b) = (1, 1, 1, 0)
//    }
//    
//    self.init(
//      .sRGB,
//      red: Double(r) / 255,
//      green: Double(g) / 255,
//      blue:  Double(b) / 255,
//      opacity: Double(a) / 255
//    )
//  }
  
  // Helper function to get a more readable color description
  //  var info: String {
  //    if let sRGBColor = self.usingColorSpace(.sRGB) {
  //      let red = Int(sRGBColor.redComponent * 255)
  //      let green = Int(sRGBColor.greenComponent * 255)
  //      let blue = Int(sRGBColor.blueComponent * 255)
  //      let alpha = Int(sRGBColor.alphaComponent * 100)
  //      return "RGB(\(red), \(green), \(blue), \(alpha)%)"
  //    } else {
  //      return color.description
  //    }
  //  }
  
}


public struct TrafficLightsModifier: ViewModifier {
  
  
  public func body(content: Content) -> some View {
    content
      .overlay(alignment: .topLeading) {
        if isPreview {
          HStack {
            
            Circle()
              .fill(Color(hex: "FE6057") ?? Color.red)
            
            Circle()
              .fill(Color(hex: "FFBC2E") ?? Color.yellow)
            
            Circle()
              .fill(Color(hex: "28C840") ?? Color.green)
            
          }
          .frame(height: 12)
          .padding(20)
        }
      }
  }
}
public extension View {
  func trafficLightsPreview() -> some View {
    self.modifier(TrafficLightsModifier())
  }
}

/// This is cool and all, but there already exists a `NSColor.colorNameComponent` 🥲
//func namedColorDescription(_ color: NSColor) -> String? {
//  let namedColors: [(NSColor, String)] = [
//    (.systemBlue, "systemBlue"),
//    (.systemBrown, "systemBrown"),
//    (.systemGray, "systemGray"),
//    (.systemGreen, "systemGreen"),
//    (.systemIndigo, "systemIndigo"),
//    (.systemOrange, "systemOrange"),
//    (.systemPink, "systemPink"),
//    (.systemPurple, "systemPurple"),
//    (.systemRed, "systemRed"),
//    (.systemTeal, "systemTeal"),
//    (.systemYellow, "systemYellow"),
//    (.black, "black"),
//    (.blue, "blue"),
//    (.brown, "brown"),
//    (.clear, "clear"),
//    (.cyan, "cyan"),
//    (.darkGray, "darkGray"),
//    (.gray, "gray"),
//    (.green, "green"),
//    (.lightGray, "lightGray"),
//    (.magenta, "magenta"),
//    (.orange, "orange"),
//    (.purple, "purple"),
//    (.red, "red"),
//    (.white, "white"),
//    (.yellow, "yellow")
//  ]
//
//  for (namedColor, name) in namedColors {
//    if color.isClose(to: namedColor) {
//      return name
//    }
//  }
//
//  return nil
//}
//
//func colorDescription(_ color: NSColor) -> String {
//  if let name = namedColorDescription(color) {
//    return name
//  }
//
//  if let sRGBColor = color.usingColorSpace(.sRGB) {
//    let red = Int(sRGBColor.redComponent * 255)
//    let green = Int(sRGBColor.greenComponent * 255)
//    let blue = Int(sRGBColor.blueComponent * 255)
//    let alpha = Int(sRGBColor.alphaComponent * 100)
//    return "RGB(\(red), \(green), \(blue), \(alpha)%)"
//  } else {
//    return color.description
//  }
//}
//
//public extension NSColor {
//
//  var displayName: String {
//    colorDescription(self)
//  }
//
//  func isClose(to other: NSColor, tolerance: CGFloat = 0.01) -> Bool {
//    guard let rgb1 = self.usingColorSpace(.sRGB),
//          let rgb2 = other.usingColorSpace(.sRGB) else {
//      return false
//    }
//
//    let redDiff = abs(rgb1.redComponent - rgb2.redComponent)
//    let greenDiff = abs(rgb1.greenComponent - rgb2.greenComponent)
//    let blueDiff = abs(rgb1.blueComponent - rgb2.blueComponent)
//    let alphaDiff = abs(rgb1.alphaComponent - rgb2.alphaComponent)
//
//    return redDiff <= tolerance && greenDiff <= tolerance && blueDiff <= tolerance && alphaDiff <= tolerance
//  }
//}
