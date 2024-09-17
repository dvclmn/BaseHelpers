//
//  File.swift
//  
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI

/// This extension allows you to create a `Color` instance from a hex string in SwiftUI. It supports the following formats:

/// 1. 3-digit hex (RGB)
/// 2. 6-digit hex (RGB)
/// 3. 8-digit hex (ARGB)
///
/// // 6-digit hex (RGB)
/// let redColor = Color(hex: "FE6057")
///
/// // 3-digit hex (RGB)
/// let blueColor = Color(hex: "00F")
///
/// // 8-digit hex (ARGB)
/// let transparentGreen = Color(hex: "8000FF00")
///
/// // In a SwiftUI View
/// struct ContentView: View {
///     var body: some View {
///         VStack {
///             Rectangle()
///                 .fill(Color(hex: "FE6057"))
///                 .frame(width: 100, height: 100)
///
///             Text("Hello, World!")
///                 .foregroundColor(Color(hex: "00F"))
///         }
///     }
/// }


public extension Color {
  var nsColour: NSColor {
    NSColor(self)
  }
}


public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

public struct TrafficLightsModifier: ViewModifier {
    
    let lights: [Color] = [
        (Color(hex: "FE6057")),
        (Color(hex: "FFBC2E")),
        (Color(hex: "28C840")),
    ]
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                if isPreview {
                    HStack {
                        ForEach(lights, id: \.self) { light in
                            Circle()
                                .fill(light)
                        }
                    }
                    .frame(height: 12)
                    .padding(20)
                }
            }
    }
}
public extension View {
    func trafficLights(
        
    ) -> some View {
        self.modifier(
            TrafficLightsModifier(
                
            )
        )
    }
}

