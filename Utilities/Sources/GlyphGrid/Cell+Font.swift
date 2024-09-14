//
//  Cell+Font.swift
//  SwiftBox
//
//  Created by Dave Coleman on 29/8/2024.
//

import SwiftUI

extension GlyphCell {
  
  
  /// For when the font is being updated, and zoom is unchanged
  ///
  public mutating func updateFont(
    fontName: FontName
  ) {
    size = calculateCellSize(fontName: fontName)
  }
  
  
  
  /// Returns both an NSFont and CTFont, for a given name and size
  ///
  func getFonts(
    fontName: String
  ) -> (NSFont, CTFont)? {
    
    guard let nsFont = NSFont.init(name: fontName, size: GlyphGrid.baseFontSize) else { return nil }
    
    let ctFont = nsFont as CTFont
    
    //    let fontMetrics: String = """
    //      Cap height: \(nsFont.capHeight)
    //      Point size: \(nsFont.pointSize)
    //      Ascender height: \(nsFont.ascender)
    //      Fixed pitch?: \(nsFont.isFixedPitch)
    //      Leading value: \(nsFont.leading)
    //      Whole font rect: \(nsFont.boundingRectForFont)
    //      """
    //
    //    print(fontMetrics)
    
    return (nsFont, ctFont)
  }
  
  
  
  func getGlyphForCharacter(
    _ character: Character = "M",
    font: CTFont
  ) -> CGGlyph? {
    
    guard let scalar = character.unicodeScalars.first else { return nil }
    let char = UniChar(scalar.value)
    var glyph = CGGlyph(0)
    let result = CTFontGetGlyphsForCharacters(font, [char], &glyph, 1)
    
    return result ? glyph : nil
  }
  
  
  
  
}
