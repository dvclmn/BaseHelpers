//
//  File.swift
//  
//
//  Created by Dave Coleman on 11/7/2024.
//

import SwiftUI
import Foundation

//
//public struct FontStyle {
//    var textStyle: Font.TextStyle
//    var design: Font.Design?
//    var weight: Font.Weight?
//    
//    init(_ textStyle: Font.TextStyle) {
//        self.textStyle = textStyle
//    }
//    
//    func makeFont() -> Font {
//        Font.system(textStyle, design: design, weight: weight)
//    }
//}
//
//public protocol FontStyleModifiable {
//    func modify(_ style: inout FontStyle)
//}
//
//public struct DesignModifier: FontStyleModifiable {
//    let design: Font.Design
//    
//    public func modify(_ style: inout FontStyle) {
//        style.design = design
//    }
//}
//
//public struct WeightModifier: FontStyleModifiable {
//    let weight: Font.Weight
//    
//    public func modify(_ style: inout FontStyle) {
//        style.weight = weight
//    }
//}
//
//@resultBuilder
//public struct FontStyleBuilder {
//    public static func buildBlock(_ components: FontStyleModifiable...) -> [FontStyleModifiable] {
//        components
//    }
//}
//
//public extension Font {
//    static func styled(_ textStyle: Font.TextStyle, @FontStyleBuilder modifiers: () -> [FontStyleModifiable] = { [] }) -> Font {
//        var style = FontStyle(textStyle)
//        modifiers().forEach { $0.modify(&style) }
//        return style.makeFont()
//    }
//    
//    static var largeTitle: Font { .styled(.largeTitle) }
//    static var title: Font { .styled(.title) }
//    static var title2: Font { .styled(.title2) }
//    static var title3: Font { .styled(.title3) }
//    static var headline: Font { .styled(.headline) }
//    static var subheadline: Font { .styled(.subheadline) }
//    static var body: Font { .styled(.body) }
//    static var callout: Font { .styled(.callout) }
//    static var footnote: Font { .styled(.footnote) }
//    static var caption: Font { .styled(.caption) }
//    static var caption2: Font { .styled(.caption2) }
//}
//
//public extension Font {
//    var rounded: Font { self.apply(DesignModifier(design: .rounded)) }
//    var serif: Font { self.apply(DesignModifier(design: .serif)) }
//    var monospaced: Font { self.apply(DesignModifier(design: .monospaced)) }
//    
//    var bold: Font { self.apply(WeightModifier(weight: .bold)) }
//    var semibold: Font { self.apply(WeightModifier(weight: .semibold)) }
//    var medium: Font { self.apply(WeightModifier(weight: .medium)) }
//    var regular: Font { self.apply(WeightModifier(weight: .regular)) }
//    var light: Font { self.apply(WeightModifier(weight: .light)) }
//    
//    func apply(_ modifier: FontStyleModifiable) -> Font {
//        var style = FontStyle(self.textStyle)
//        modifier.modify(&style)
//        return style.makeFont()
//    }
//    
//    private var textStyle: Font.TextStyle {
//        // This is a simplification. In a real implementation, you'd need to
//        // determine the text style from the font. This might require using
//        // private API or coming up with a different solution.
//        .body
//    }
//}

/// Custom fonts?
//extension FontStyle {
//    var customName: String?
//    var size: CGFloat?
//    
//    func makeFont() -> Font {
//        if let customName = customName, let size = size {
//            return Font.custom(customName, size: size)
//        }
//        return Font.system(textStyle, design: design, weight: weight)
//    }
//}
//
//struct CustomFontModifier: FontStyleModifiable {
//    let name: String
//    let size: CGFloat
//    
//    func modify(_ style: inout FontStyle) {
//        style.customName = name
//        style.size = size
//    }
//}
//
//extension Font {
//    static func custom(_ name: String, size: CGFloat) -> Font {
//        .styled(.body) {
//            CustomFontModifier(name: name, size: size)
//        }
//    }
//}



//public extension Font {
//    
//    static var bodyCustom: Font {
//        return Font.system(.body, weight: .medium)
//    }
//    
//    static var captionCustom: Font {
//        return Font.system(.footnote, design: .rounded, weight: .semibold)
//    }
//    
//    static var titleLarge: Font {
//        return Font.system(.largeTitle, design: .rounded, weight: .semibold)
//    }
//    
//    static var titleCustom: Font {
//        return Font.system(.title, design: .rounded, weight: .semibold)
//    }
//    
//    static var title2Custom: Font {
//        return Font.system(.title2, design: .rounded, weight: .semibold)
//    }
//    
//    static var headlineCustom: Font {
//        return Font.system(.headline, design: .rounded, weight: .bold)
//            
//    }
//}
