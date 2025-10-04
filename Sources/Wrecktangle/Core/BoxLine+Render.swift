//
//  BoxLine+Render.swift
//  BoxCore
//
//  Created by Dave Coleman on 13/9/2024.
//

import BaseHelpers

public extension BoxCore.BoxLine {

  func render() -> String {

    let renderedContent: MultilineString
    
//    print("Leading cap: \(leadingCap.content). Trailing cap: \(trailingCap.content)")
    
    renderedContent = MultilineString(content.rawContent)

    let joinedContent = leadingCap.content + renderedContent + trailingCap.content
    
    return joinedContent.string
    
  }
  
  
}
