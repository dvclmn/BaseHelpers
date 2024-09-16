//
//  File.swift
//  
//
//  Created by Dave Coleman on 8/7/2024.
//

import Foundation
import SwiftUI

#if os(macOS)

public struct SheetFrame: ViewModifier {
    
    let minWidth: CGFloat
    let maxWidth: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .frame(
                minWidth: minWidth,
                idealWidth: (minWidth + maxWidth) / 2,
                maxWidth: maxWidth,
                minHeight: minHeight,
                idealHeight: (minHeight + maxHeight) / 2,
                maxHeight: maxHeight
            )
    }
}
public extension View {
    func sheetFrame(
        minWidth: CGFloat = 340,
        maxWidth: CGFloat = 680,
        minHeight: CGFloat = 400,
        maxHeight: CGFloat = 960
    ) -> some View {
        self.modifier(
            SheetFrame(
                minWidth: minWidth,
                maxWidth: maxWidth,
                minHeight: minHeight,
                maxHeight: maxHeight
            )
        )
    }
}

#endif
