//
//  StyleHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI

struct Styles {
    static let cornerRadiusSmall:       CGFloat = 6
    static let cornerRadiusLarge:       CGFloat = 10
    
    /// Animation
    static let animationQuick:          Animation = .easeOut(duration: 0.08)
    static let animation:               Animation = .easeOut(duration: 0.2)
    static let animationSlower:         Animation = .easeInOut(duration: 0.6)
    
    /// Rounding
    static let roundingTiny:            Double = 2
    static let roundingSmall:           Double = 5
    static let roundingMedium:          Double = 8
    static let roundingLarge:           Double = 12
    static let roundingHuge:            Double = 20
    
}

struct Icons {
    static let arrowDown: String = "arrow.down"
    
}
