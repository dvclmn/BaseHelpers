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

    let action: () -> Void
    
    public func body(content: Content) -> some View {
    
        ZStack {
            Color.clear
                .frame(maxWidth:.infinity, maxHeight:.infinity)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
            
    }
}
public extension View {
    func tapOffToDismiss(action: @escaping () -> Void) -> some View {
        self.modifier(
            TapOffToDismiss(action: action)
        )
    }
}
#endif
