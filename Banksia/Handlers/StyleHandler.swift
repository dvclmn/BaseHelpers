//
//  StyleHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import GeneralStyles

extension Styles {
    
//    static let sidebarWidth:            Double = 180
    static let iconWidth:               Double = 20
    
    static let paddingText:             Double = 18
}

enum OstiaFont: String {
    case italic = "-Italic"
    case bookItalic = "-BookItalic"
    
    var font: String {
        "OstiaAntica" + self.rawValue
    }
    
}
