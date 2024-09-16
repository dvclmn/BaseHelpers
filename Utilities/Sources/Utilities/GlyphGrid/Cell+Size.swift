//
//  CellSize.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import SwiftUI

extension GlyphCell {
  
  public static let example: GlyphCell = GlyphCell(fontName: .menlo)

  /// Get cell size when you don't yet have the `NSFont`
  ///
  func calculateCellSize(
    fontName: FontName,
    minWidth: CGFloat = 1.5
  ) -> CGSize {
    
//    print("Calculating cell size, for \(fontName.rawValue)")
    
    guard let (nsFont, _) = getFonts(fontName: fontName.rawValue) else { return .zero }
    
    let size: CGSize = calculateCellSize(for: nsFont, minWidth: minWidth)
    
    return size
    
  }
  
  /// Get cell size when already have the `NSFont`. This is useful in that it
  /// provides a way to perform the size claculation *without* the performance
  /// hit of obtaining the right font.
  ///
  func calculateCellSize(
    for font: NSFont,
    minWidth: CGFloat = 1.5
  ) -> CGSize {
    
//    print("Let's calculate the cell size, for font: \(font.fontName)")
    
    let ctFont = font as CTFont
    
    guard let cgGlyph = getGlyphForCharacter(font: ctFont) else {
      print("Couldn't get CGGlyph")
      return .zero
    }
    
    let glyphWidth: CGFloat = font.advancement(forCGGlyph: cgGlyph).width
    
    let glyphHeight: CGFloat = font.ascender - font.descender + font.leading
    
    let finalWidth: CGFloat = fontName.normalised(baseValue: glyphWidth)
    let finalHeight: CGFloat = fontName.normalised(baseValue: glyphHeight)
    
    let size = CGSize(width: max(minWidth, finalWidth), height: max(minWidth, finalHeight))
//    print("Here is the final cell size: \(size)")
    
    return size
  }
  
  

} // END glyph cell extension

