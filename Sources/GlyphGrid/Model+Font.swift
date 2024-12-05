//
//  Cell+Font.swift
//  SwiftBox
//
//  Created by Dave Coleman on 29/8/2024.
//

import SwiftUI
import BaseHelpers


public enum GridFont: String, CaseIterable, Hashable, Equatable, Sendable, Identifiable {
  
  case menlo = "Menlo"
  case sfMono = "SF Mono"
  case courier = "Courier New"
  case monaco = "Monaco"
  case ibm = "AcPlus IBM BIOS"
  
  public var id: String {
    self.rawValue
  }
  
  public enum NormaliseParameter {
    case fontSize
    case width
    case weight
  }
  
  public struct Normalisers {
    let fontSize: CGFloat
    let width: CGFloat
    let weight: CGFloat
  }
  
  public var normalisers: Normalisers {
    switch self {
      case .menlo:
        Normalisers(
          fontSize: 1.0,
          width: 1.0,
          weight: 1.0
        )
      case .sfMono:
        Normalisers(
          fontSize: 1.0,
          width: 1.0,
          weight: 1.0
        )
      case .courier:
        Normalisers(
          fontSize: 1.1,
          width: 1.0,
          weight: 1.0
        )
      case .monaco:
        Normalisers(
          fontSize: 1.0,
          width: 1.0,
          weight: 1.0
        )
      case .ibm:
        Normalisers(
          fontSize: 0.8,
          width: 1.0,
          weight: 1.0
        )
    }
  }
  
  public func normalised(
    for parameter: NormaliseParameter = .fontSize,
    baseValue: CGFloat
  ) -> CGFloat {
    let factor: CGFloat
    switch parameter {
      case .fontSize:
        factor = normalisers.fontSize
      case .width:
        factor = normalisers.width
      case .weight:
        factor = normalisers.weight
    }
    return baseValue * factor
  }
}


//extension GlyphCell {
  
  
  /// For when the font is being updated, and zoom is unchanged
  ///
//  public mutating func updateFont(
//    fontName: FontName
//  ) {
//    size = calculateCellSize(fontName: fontName)
//  }
//  
//  
//  
  /// Returns both an NSFont and CTFont, for a given name and size
  ///
//  func getFonts(
//    fontName: String
//  ) -> (OFont, CTFont)? {
//    
//    guard let nsFont = OFont.init(name: fontName, size: GlyphGrid.baseFontSize) else { return nil }
//    
//    let ctFont = nsFont as CTFont
//    
//    //    let fontMetrics: String = """
//    //      Cap height: \(nsFont.capHeight)
//    //      Point size: \(nsFont.pointSize)
//    //      Ascender height: \(nsFont.ascender)
//    //      Fixed pitch?: \(nsFont.isFixedPitch)
//    //      Leading value: \(nsFont.leading)
//    //      Whole font rect: \(nsFont.boundingRectForFont)
//    //      """
//    //
//    //    print(fontMetrics)
//    
//    return (nsFont, ctFont)
//  }
//  
  
//  
//  func getGlyphForCharacter(
//    _ character: Character = "M",
//    font: CTFont
//  ) -> CGGlyph? {
//    
//    guard let scalar = character.unicodeScalars.first else { return nil }
//    let char = UniChar(scalar.value)
//    var glyph = CGGlyph(0)
//    let result = CTFontGetGlyphsForCharacters(font, [char], &glyph, 1)
//    
//    return result ? glyph : nil
//  }
//  
//  
//  
  
//}
