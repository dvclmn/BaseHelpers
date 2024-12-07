//
//  Glyphs.swift
//  Collection
//
//  Created by Dave Coleman on 7/12/2024.
//

public protocol Glyph {
  var character: Character { get }
}

public protocol RotatableGlyph: Glyph {
  var orientation: GlyphOrientation { get set }
  
  func rotate(_ direction: RotationDirection, orientation: inout GlyphOrientation)
}

public enum GlyphOrientation {
  case `default`
  case quarter
  case half
  case threeQuarter
}

public enum RotationDirection {
  case clockwise
  case counterClockwise
}
