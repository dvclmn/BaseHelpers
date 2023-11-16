//
//  PreferencesHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI

extension BanksiaHandler {
    enum UIScale: Int {
        case small = 0, standard, medium, large
        
        var description: String {
            switch self {
            case .small: return "Small"
            case .standard: return "Standard"
            case .medium: return "Medium"
            case .large: return "Large"
            }
        }
    }
    
    var uiScale: UIScale {
        switch globalTextSize {
        case ..<0.9: return .small
        case 0.9..<1.0: return .standard
        case 1.0..<1.1: return .medium
        default: return .large
        }
    }
}

