//
//  TextStyles.swift
//  Paperbark
//
//  Created by Dave Coleman on 9/10/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

enum Typography {
    case heading1
    case heading2
    case heading3
    case body
    case bold
    case italic
    case small
    case code
    case icon
    case displayIcon
}

struct TypographyModifier: ViewModifier {
    @EnvironmentObject var bk: BanksiaHandler
    var style: Typography
    var size: CGFloat?
    var weight: Font.Weight?
    var opacity: Double?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        let defaultSize = defaultFontSize(for: style)
        let fontSize = size ?? defaultSize
        let fontWeight = weight ?? defaultWeight(for: style)
        let textOpacity = opacity ?? defaultOpacity(for: style)
        
        switch style {
        case .heading1:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        case .heading2:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        case .heading3:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        case .body:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        case .bold:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        case .italic:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).italic().opacity(textOpacity)
        case .small:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        case .code:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .monospaced)).opacity(textOpacity)
        case .icon:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        case .displayIcon:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: .default)).opacity(textOpacity)
        } // END switch
    } // END view body
    private func defaultFontSize(for style: Typography) -> CGFloat {
        switch style {
        case .heading1: return 34
        case .heading2: return 28
        case .heading3: return 22
        case .body: return 16
        case .bold: return 16
        case .italic: return 16
        case .small: return 13
        case .code: return 15
        case .icon: return 20
        case .displayIcon: return 48
        }
    } // END default font size
    
    private func defaultOpacity(for style: Typography) -> Double {
        switch style {
        case .small: return 0.5
        default: return 1.0
        }
    } // END default opacity
    
    private func defaultWeight(for style: Typography) -> Font.Weight {
        switch style {
        case .heading1: return .heavy
        case .heading2: return .bold
        case .heading3: return .medium
        case .body: return .regular
        case .bold: return .bold
        case .italic: return .regular
        case .small: return .medium
        case .code: return .medium
        case .icon: return .regular
        case .displayIcon: return .regular
        }
    } // END default weight
    
} // END TypographyModifier

extension View {
    func fontStyle(_ style: Typography, size: CGFloat? = nil, weight: Font.Weight? = nil, opacity: Double? = nil) -> some View {
        self.modifier(TypographyModifier(style: style, size: size, weight: weight, opacity: opacity))
    }
}
