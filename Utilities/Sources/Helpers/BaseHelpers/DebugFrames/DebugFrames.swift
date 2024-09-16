//
//  DebugFrames.swift
//
//
//  Created by Dave Coleman on 21/6/2024.
//

import Foundation
import SwiftUI

//public struct EnvironmentSettings {
//    public static var isShowingFrames: Bool {
//        return ProcessInfo.processInfo.environment["IS_SHOWING_FRAMES"] == "YES"
//    }
//}
//    .border(colour.opacity(EnvironmentSettings.isShowingFrames ? 0.2 : 0))

public struct DebugFrames: ViewModifier {
    
    var label: String
    var colour: Color
    var width: Double
    var isOn: Bool
    
    
    public func body(content: Content) -> some View {
        content
        
#if DEBUG
            .border(colour.opacity(isOn ? 0.2 : 0), width: width)
            .overlay(alignment: .topTrailing) {
                TextOverlay()
            }
#endif
    }
}

extension DebugFrames {
    @ViewBuilder
    func TextOverlay() -> some View {
        
        if isOn {
        Text(label)
            .foregroundStyle(colour.opacity(0.4))
            .font(.caption)
            .padding()
        }
    }
}

public extension View {
    func debugFrame(
        _ label: String = "",
        colour: Color = .green,
        width: Double = 1,
        isOn: Bool = false
    ) -> some View {
        self.modifier(
            DebugFrames(
                label: label,
                colour: colour,
                width: width,
                isOn: isOn
            )
        )
    }
}

struct DebugFrameExampleView: View {
    
    var body: some View {
        
        Text("Hello")
            .padding(100)
            .debugFrame(
                "Text",
                colour: .purple,
                width: 2,
                isOn: true
            )
        
    }
}
#Preview {
    DebugFrameExampleView()
        .padding(40)
        .frame(width: 600, height: 700)
        .background(.black.opacity(0.6))
}
