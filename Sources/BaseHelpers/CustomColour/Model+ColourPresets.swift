//
//  Model+ColourExamples.swift
//  BaseComponents
//
//  Created by Dave Coleman on 7/6/2025.
//

import SwiftUI
import BaseStyles

//public enum RGBSwatch: String {
//  /// ASCII
//  case asciiBlack
//  case asciiBlue
//  case asciiBrown
//  case asciiGreen
//  case asciiGrey
//  case asciiMaroon
//  case asciiPurple
//  case asciiRed
//  case asciiTeal
//  case asciiTealDull
//  case asciiWarmWhite
//  case asciiWhite
//  case asciiYellow
//
//  /// Black
//  case blackTrue
//  
//  /// Blue
//  case blue10
//  case blue20
//  case blue30
//  case blue40
//  case blue50
//  case blue60
//  
//  /// Brown
//  case brown30
//  case brown40
//  case brown50
//  case brown60
//  
//  public var colour: Color {
//    Color("swatch/\(rawValue)", bundle: .module)
//  }
//}


extension RGBColour {
  /// Primary colors
  public static let red = RGBColour(red: 1, green: 0, blue: 0)
  public static let green = RGBColour(red: 0, green: 1, blue: 0)
  public static let blue = RGBColour(red: 0, green: 0, blue: 1)
  
  /// Grayscale
  public static let black = RGBColour(red: 0, green: 0, blue: 0)
  public static let white = RGBColour(red: 1, green: 1, blue: 1)
  public static let grey = RGBColour(red: 0.5, green: 0.5, blue: 0.5)
  public static let lightGray = RGBColour(red: 0.75, green: 0.75, blue: 0.75)
  public static let greyMid = RGBColour(red: 0.25, green: 0.25, blue: 0.25)
  public static let greyDark = RGBColour(red: 0.1, green: 0.1, blue: 0.108)
  
  /// Secondary colors
  public static let yellow = RGBColour(red: 1, green: 1, blue: 0)
  public static let cyan = RGBColour(red: 0, green: 1, blue: 1)
  public static let magenta = RGBColour(red: 1, green: 0, blue: 1)
  
  /// Common colors
  public static let orange = RGBColour(red: 1, green: 0.5, blue: 0)
  public static let purple = RGBColour(red: 0.5, green: 0, blue: 0.5)
  public static let brown = RGBColour(red: 0.6, green: 0.4, blue: 0.2)
  public static let pink = RGBColour(red: 1, green: 0.75, blue: 0.8)
  
  /// Dark colors
  public static let purpleDark = RGBColour(
    red: 0.124,
    green: 0.102,
    blue: 0.204
  )
  public static let greenDark = RGBColour(
    red: 0.103,
    green: 0.202,
    blue: 0.173
  )
  public static let oliveDark = RGBColour(
    red: 0.129,
    green: 0.135,
    blue: 0.062
  )
  public static let brownDark = RGBColour(
    red: 0.140,
    green: 0.102,
    blue: 0.065
  )

  
  /// Transparent
  public static let clear = RGBColour(red: 0, green: 0, blue: 0, alpha: 0)
}
