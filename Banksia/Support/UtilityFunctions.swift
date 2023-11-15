//
//  UtilityFunctions.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
