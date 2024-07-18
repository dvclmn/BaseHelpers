// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  ResponsiveTitle.swift
//  Eucalypt
//
//  Created by Dave Coleman on 21/3/2024.
//

import Foundation
import SwiftUI
//import BaseUtilities

public struct ResponsiveText: ViewModifier {
    
    /// `minContentWidth` and `widthForMaxFontSize` effectively form a range between which the font size will scale
    var minContentWidth: Double
    var widthForMaxFontSize: Double
    var customFont: String?
    var minFontSize: CGFloat
    var maxFontSize: CGFloat
    
    @State private var viewDimensions: CGSize = .zero
    @State private var interpolatedFontSize: Double = 0
    
    public func body(content: Content) -> some View {
        
        Group {
            if let customFont = customFont {
                content
                    .font(.custom(customFont, size: interpolatedFontSize))
                
            } else {
                content
                    .font(.system(size: interpolatedFontSize))
                
            }
        }
            .frame(maxWidth: .infinity, alignment: .leading)
//            .readSize { size in
//                print("Responsive text width: \(size.width)")
//                self.viewDimensions = size
//            }
            .onChange(of: viewDimensions) {
                let clampedWidth = min(max(viewDimensions.width, minContentWidth), widthForMaxFontSize)
                let t = (clampedWidth - minContentWidth) / (widthForMaxFontSize - minContentWidth)
                let interpolatedFontSize = lerp(min: minFontSize, max: maxFontSize, t: t)
                self.interpolatedFontSize = interpolatedFontSize
            }
    }
    
    private func lerp(min: CGFloat, max: CGFloat, t: CGFloat) -> CGFloat {
        return (1 - t) * min + t * max
    }
}
public extension View {
    func responsiveText(
        minContentWidth: Double = 300,
        widthForMaxFontSize: CGFloat = 800,
        customFont: String? = nil,
        minFontSize: CGFloat,
        maxFontSize: CGFloat
    ) -> some View {
        self.modifier(
            ResponsiveText(
                minContentWidth: minContentWidth,
                widthForMaxFontSize: widthForMaxFontSize,
                customFont: customFont,
                minFontSize: minFontSize,
                maxFontSize: maxFontSize
            )
        )
    }
}


