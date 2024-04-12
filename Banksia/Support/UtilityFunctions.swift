//
//  UtilityFunctions.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import SwiftUI
import SwiftData

extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct HandyButton: View {
    
    var label: String
    var icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(label, systemImage: icon)
        } // END button
    }
} // END

#if os(macOS)
struct VisualEffectView : NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground
        return view
    }
    func updateNSView(_ view: NSView, context: Context) { }
}
#endif

// MARK: corner radius border
fileprivate struct ModifierCornerRadiusWithBorder: ViewModifier {
    var radius: CGFloat
    var borderLineWidth: CGFloat = 1
    var borderColor: Color = .gray
    var antialiased: Bool = true
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(self.radius, antialiased: self.antialiased)
            .overlay(
                RoundedRectangle(cornerRadius: self.radius)
                    .strokeBorder(self.borderColor, lineWidth: self.borderLineWidth, antialiased: self.antialiased)
            )
    }
}

extension View {
    // Usage: `.cornerRadiusWithBorder(radius: 6, borderLineWidth: 1, borderColor: Color(.properties))`
    func cornerRadiusWithBorder(radius: CGFloat, borderLineWidth: CGFloat, borderColor: Color = .gray, antialiased: Bool = true) -> some View {
        modifier(ModifierCornerRadiusWithBorder(radius: radius, borderLineWidth: borderLineWidth, borderColor: borderColor, antialiased: antialiased))
    }
}

public var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}


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
