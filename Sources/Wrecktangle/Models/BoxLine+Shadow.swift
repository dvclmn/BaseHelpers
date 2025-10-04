//
//  BoxLine+Shadow.swift
//  BoxCore
//
//  Created by Dave Coleman on 15/9/2024.
//

//public extension BoxCore.BoxLine {
//  
//  func generateShadow() -> String {
//    
//    let shadow = self.theme.shadow
//    guard shadow.type != .none else { return "" }
//    
//    let shadowChar = shadow.strength.character
//    
//    let lineWidth = remainingWidth + leadingCap.content.width + trailingCap.content.width
//    
//    var shadowLine = String(repeating: shadowChar, count: lineWidth)
//    
//    switch shadow.lightSource {
//      case .topLeading, .bottomLeading:
//        shadowLine = " " + String(shadowLine.dropLast())
//      case .topTrailing, .bottomTrailing:
//        shadowLine = String(shadowLine.dropFirst()) + " "
//    }
//    
//    return shadowLine
//  }
//  
//}
