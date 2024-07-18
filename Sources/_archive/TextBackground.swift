//
//  File.swift
//  
//
//  Created by Dave Coleman on 5/6/2024.
//

import Foundation
import SwiftUI

public struct TextBackgroundModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .caption()
            .padding(.horizontal, 3)
            .padding(.vertical, 2)
            .background(.black.opacity(0.2))
    }
}
public extension View {
    func textBackground(
    ) -> some View {
        self.modifier(
            TextBackgroundModifier(
            )
        )
    }
}
