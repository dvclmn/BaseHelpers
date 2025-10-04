//
//  BoxLine+Precondition.swift
//  BoxCore
//
//  Created by Dave Coleman on 13/9/2024.
//

extension BoxCore.BoxLine {
  
  static func checkConditions(leadingCap: BoxCore.BoxPart, trailingCap: BoxCore.BoxPart) -> (condition: Bool, message: String) {
    
    let heightCheck: Bool = leadingCap.height == 1 && trailingCap.height == 1
    let message: String = """
    Caps for text-based lines cannot exceed a height of 1.
    This allows line height to be calculated correctly.
    Provided Cap heights: Leading '\(leadingCap.height)`, Trailing '\(trailingCap.height)'
    """
    
    return (heightCheck, message)
    
  }

  
}
