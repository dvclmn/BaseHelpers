//
//  Model+Hex.swift
//  BaseComponents
//
//  Created by Dave Coleman on 7/6/2025.
//

//import Foundation

// MARK: - Hex Conversion
//extension RGBColour {
//  
//  /// Initialize from a hex string (e.g., "#FF0000", "FF0000", "#FF0000FF")
//  public init?(hex: String, name: String?) {
//    
//    let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//      .replacingOccurrences(of: "#", with: "")
//    print("Hex string without #: \(hexString)")
//    
//    /// Support both RGB (6 chars) and RGBA (8 chars)
//    guard hexString.count == 6 || hexString.count == 8 else {
//      return nil
//    }
//    
//    guard let hexValue = UInt64(hexString, radix: 16) else {
//      return nil
//    }
//    print("Ensured hex value is UInt64 (radix 16): \(hexValue)")
//    
//    let red, green, blue, alpha: Double
//    
//    if hexString.count == 8 {
//      /// RGBA format
//      
//      red = Double((hexValue & 0xFF000000) >> 24) / 255.0
//      green = Double((hexValue & 0x00FF0000) >> 16) / 255.0
//      blue = Double((hexValue & 0x0000FF00) >> 8) / 255.0
//      alpha = Double(hexValue & 0x000000FF) / 255.0
//    } else {
//      /// RGB format
//      red = Double((hexValue & 0xFF0000) >> 16) / 255.0
//      green = Double((hexValue & 0x00FF00) >> 8) / 255.0
//      blue = Double(hexValue & 0x0000FF) / 255.0
//      alpha = 1.0
//    }
//    
//    /// Convert from sRGB to linear RGB
//    self.init(
//      red: Self.sRGBToLinear(red),
//      green: Self.sRGBToLinear(green),
//      blue: Self.sRGBToLinear(blue),
//      alpha: alpha
//    )
//  }
  
//  /// Convert to hex string representation
//  public var hexString: String {
//    // Convert from linear RGB to sRGB for hex representation
//    let sRGBRed = Self.linearToSRGB(red.value)
//    let sRGBGreen = Self.linearToSRGB(green.value)
//    let sRGBBlue = Self.linearToSRGB(blue.value)
//    
//    let redInt = Int(round(sRGBRed * 255))
//    let greenInt = Int(round(sRGBGreen * 255))
//    let blueInt = Int(round(sRGBBlue * 255))
//    
//    if alpha.value < 1.0 {
//      let alphaInt = Int(round(alpha.value * 255))
//      return String(format: "#%02X%02X%02X%02X", redInt, greenInt, blueInt, alphaInt)
//    } else {
//      return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
//    }
//  }
//  
//  /// Convert to hex string without the # prefix
//  public var hexStringWithoutPrefix: String {
//    String(hexString.dropFirst())
//  }
  
  // MARK: - sRGB ↔ Linear RGB Conversion
  
//  /// Convert sRGB component to linear RGB
//  private static func sRGBToLinear(_ component: Double) -> Double {
//    if component <= 0.04045 {
//      return component / 12.92
//    } else {
//      return pow((component + 0.055) / 1.055, 2.4)
//    }
//  }
//  
//  /// Convert linear RGB component to sRGB
//  private static func linearToSRGB(_ component: Double) -> Double {
//    if component <= 0.0031308 {
//      return component * 12.92
//    } else {
//      return 1.055 * pow(component, 1.0 / 2.4) - 0.055
//    }
//  }
  
//}
