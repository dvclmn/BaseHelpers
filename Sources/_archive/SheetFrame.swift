//
//  File.swift
//  
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation
import SwiftUI

#if os(macOS)

public struct SheetFrame: ViewModifier {
    
    let macModalMinWidth:     Double = 340
    let macModalMaxWidth:     Double = 680
    let macModalMinHeight:    Double = 400
    let macModalMaxHeight:    Double = 960
    
    public func body(content: Content) -> some View {
        content
            .frame(
                minWidth: macModalMinWidth,
                idealWidth: (macModalMinWidth + macModalMaxWidth) / 2,
                maxWidth: macModalMaxWidth,
                minHeight: macModalMinHeight,
                idealHeight: (macModalMinHeight + macModalMaxHeight) / 2,
                maxHeight: macModalMaxHeight
            )
    }
}
public extension View {
    func sheetFrame() -> some View {
        self.modifier(SheetFrame())
    }
}

#endif
