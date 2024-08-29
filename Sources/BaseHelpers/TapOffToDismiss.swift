//
//  File.swift
//  
//
//  Created by Dave Coleman on 4/7/2024.
//

import Foundation
import SwiftUI

#if os(macOS)


public struct TapOffToDismiss: ViewModifier {
    
    let alignment: Alignment
    let action: () -> Void
    
    public func body(content: Content) -> some View {
    
        ZStack {
            Color.clear
                .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .leading)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    action()
                }
            VStack {
                content
                    .onExitCommand {
                        action()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        }
            
    }
}
public extension View {
    func tapOffToDismiss(
        alignment: Alignment = .leading,
        action: @escaping () -> Void = { }
    ) -> some View {
        self.modifier(
            TapOffToDismiss(
                alignment: alignment,
                action: action
            )
        )
    }
}
#endif
