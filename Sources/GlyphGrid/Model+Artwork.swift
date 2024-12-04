//
//  Artwork.swift
//  SwiftBox
//
//  Created by Dave Coleman on 29/8/2024.
//

import Foundation

public typealias GridArtwork = [[GlyphGrid.Cell]]

extension GlyphGrid {
  public struct Artwork: Equatable, Sendable {

    public var content: GridArtwork

    public var dimensions: GridDimensions {
      let rows = content.count
      let columns = content.isEmpty ? 0 : content[0].count
      return GridDimensions(rows: rows, columns: columns)
    }

    public init(
      content: GridArtwork
    ) {
      self.content = content
    }

  }
}

extension GlyphGrid.Artwork {

  public static func fromCharacters(_ characters: [[Character]]) -> Self {
    .init(
      content: characters.map { row in
        row.map { GlyphGrid.Cell(character: $0) }
      })
  }

  public static let noArt: Self = fromCharacters([
    ["N"],
    ["o"],
    [" "],
    ["a"],
    ["r"],
    ["t"],
  ])

  public static let empty: Self = .init(content: [[.init(character: " ")]])
}
