//
//  BoxLine+Text.swift
//  BoxCore
//
//  Created by Dave Coleman on 13/9/2024.
//

public extension BoxCore.BoxLine {
  
  struct TextContent: LineContent {
    public let rawContent: String
    public let lineLimit: Int
    
    init(_ text: String, lineLimit: Int = 0) {
      self.rawContent = text
      self.lineLimit = lineLimit
    }
  }
  
}
