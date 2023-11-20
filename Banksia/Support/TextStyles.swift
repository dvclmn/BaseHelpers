//
//  TextStyles.swift
//  Paperbark
//
//  Created by Dave Coleman on 9/10/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

enum Typography {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2
}

struct TypographyModifier: ViewModifier {
    @EnvironmentObject var bk: BanksiaHandler
    var style: Typography
    var size: CGFloat?
    var weight: Font.Weight?
    var design: Font.Design?
    var opacity: Double?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        let fontSize = size ?? defaultFontSize(for: style)
        let lineHeight = size ?? defaultLineHeight(for: style)
        let fontWeight = weight ?? defaultWeight(for: style)
        let fontDesign = design ?? .default
        let textOpacity = opacity ?? defaultOpacity(for: style)
        
        switch style {
        default:
            content.font(.system(size: fontSize * CGFloat(bk.globalTextSize), weight: fontWeight, design: fontDesign)).lineSpacing(lineHeight).opacity(textOpacity)
        } // END switch
    } // END view body
    private func defaultFontSize(for style: Typography) -> CGFloat {
        switch style {
        case .largeTitle: return 26
        case .title1: return 22
        case .title2: return 17
        case .title3: return 15
        case .headline: return 13
        case .body: return 13
        case .callout: return 12
        case .subheadline: return 11
        case .footnote: return 10
        case .caption1: return 10
        case .caption2: return 10
        }
    } // END default font size
    
    private func defaultLineHeight(for style: Typography) -> CGFloat {
        switch style {
        case .largeTitle: return 32
        case .title1: return 26
        case .title2: return 22
        case .title3: return 20
        case .headline: return 16
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        case .footnote: return 13
        case .caption1: return 13
        case .caption2: return 13
        }
    } // END default font size
    
    private func defaultOpacity(for style: Typography) -> Double {
        switch style {
        case .caption1: return 1.0
        default: return 1.0
        }
    } // END default opacity
    
    private func defaultWeight(for style: Typography) -> Font.Weight {
        switch style {
        case .largeTitle: return .regular
        case .title1: return .regular
        case .title2: return .regular
        case .title3: return .regular
        case .headline: return .bold
        case .body: return .regular
        case .callout: return .regular
        case .subheadline: return .regular
        case .footnote: return .regular
        case .caption1: return .regular
        case .caption2: return .medium
        }
    } // END default weight
    
} // END TypographyModifier

extension View {
    func fontStyle(_ style: Typography, size: CGFloat? = nil, weight: Font.Weight? = nil, design: Font.Design? = nil, opacity: Double? = nil) -> some View {
        self.modifier(TypographyModifier(style: style, size: size, weight: weight, design: design, opacity: opacity))
    }
}
