//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI

public struct ModifierFlagsKey: EnvironmentKey {
    public static let defaultValue = Set<NSEvent.ModifierFlags>()
}


public extension EnvironmentValues {
    var modifierKeys: Set<NSEvent.ModifierFlags> {
        get { self[ModifierFlagsKey.self] }
        set { self[ModifierFlagsKey.self] = newValue }
    }
}

public struct ModifierKeysModifier: ViewModifier {
    @State private var modifierKeys = Set<NSEvent.ModifierFlags>()
    
    private let allModifiers: Set<NSEvent.ModifierFlags> = [
        .shift,
        .control,
        .option,
        .command
    ]
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
                    modifierKeys = allModifiers.filter { event.modifierFlags.contains($0) }
                    return event
                }
            }
            .environment(\.modifierKeys, modifierKeys)
    }
}

public extension View {
    func readModifierKeys() -> some View {
        self.modifier(ModifierKeysModifier())
    }
}
