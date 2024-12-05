//
//  Artwork.swift
//  SwiftBox
//
//  Created by Dave Coleman on 29/8/2024.
//

import Foundation

//extension GlyphGrid {
//
//  public struct Artwork: Equatable, Sendable {
//
//
//    public init(
//      content: GridArtwork
//    ) {
//      self.content = content
//    }
//
//  }
//}

extension GlyphGrid {

  public static func artworkFromCharacters(_ characters: [[Character]]) -> GridArtwork {
    let result = characters.map { row in
      row.map { GlyphGrid.Cell(character: $0) }
    }
    return result
  }

  public static let noArt: GridArtwork = artworkFromCharacters([
    ["N"],
    ["o"],
    [" "],
    ["a"],
    ["r"],
    ["t"],
  ])

  public static let empty: GridArtwork = .init()
  
  
}
