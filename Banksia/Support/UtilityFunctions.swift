//
//  UtilityFunctions.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import SwiftUI
import SwiftData

extension View {
    public func cursor(_ cursor: NSCursor) -> some View {
        if #available(macOS 13.0, *) {
            return self.onContinuousHover { phase in
                switch phase {
                case .active(_):
                    guard NSCursor.current != cursor else { return }
                    cursor.push()
                case .ended:
                    NSCursor.pop()
                }
            }
        } else {
            return self.onHover { inside in
                if inside {
                    cursor.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
}



// MARK: - Copy to clipboard
protocol PasteboardCopying {
    func setString(_ string: String)
}

#if canImport(AppKit)
import AppKit

extension NSPasteboard: PasteboardCopying {
    func setString(_ string: String) {
        clearContents()
        setString(string, forType: .string)
    }
}
#endif

#if canImport(UIKit)
import UIKit

extension UIPasteboard: PasteboardCopying {
    func setString(_ string: String) {
        self.string = string
    }
}
#endif


extension StringProtocol {

    func ranges<T: StringProtocol>(
        of stringToFind: T,
        options: String.CompareOptions = [],
        locale: Locale? = nil
    ) -> [Range<AttributedString.Index>] {

        var ranges: [Range<String.Index>] = []
        var attributedRanges: [Range<AttributedString.Index>] = []
        let attributedString = AttributedString(self)

        while let result = range(
            of: stringToFind,
            options: options,
            range: (ranges.last?.upperBound ?? startIndex)..<endIndex,
            locale: locale
        ) {
            ranges.append(result)
            let start = AttributedString.Index(result.lowerBound, within: attributedString)!
            let end = AttributedString.Index(result.upperBound, within: attributedString)!
            attributedRanges.append(start..<end)
        }
        return attributedRanges
    }
}


// MARK: - Grain overlay
struct GrainOverlay: ViewModifier {
    var opacity: Double
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Image(.fuji)
                    .resizable(resizingMode: .tile)
                    .drawingGroup()
                    .blendMode(.overlay)
                    .opacity(opacity)
            )
    }
}
extension View {
    func grainOverlay(
        opacity: Double = 0.8
    ) -> some View {
        self.modifier(
            GrainOverlay(
                opacity: opacity
            )
        )
    }
}
