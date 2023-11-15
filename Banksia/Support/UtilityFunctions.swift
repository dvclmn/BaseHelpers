//
//  UtilityFunctions.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import SwiftUI
import SwiftData

extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct HandyButton: View {
    
    var label: String
    var icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(label, systemImage: icon)
        } // END button
    }
} // END
