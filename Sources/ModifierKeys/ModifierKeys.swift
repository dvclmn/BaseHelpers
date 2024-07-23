//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI




public struct ModifierKey: Sendable, Identifiable, Hashable {
    public var id: UInt {
        self.modifier.rawValue
    }
    public var modifier: NSEvent.ModifierFlags
}

public struct ModifierKeysKey: EnvironmentKey {
    public static let defaultValue = Set<ModifierKey>()
}

public extension EnvironmentValues {
    var modifierKeys: Set<ModifierKey> {
        get { self[ModifierKeysKey.self] }
        set { self[ModifierKeysKey.self] = newValue }
    }
}

public struct ModifierKeysModifier: ViewModifier {
    @State private var modifierKeys = Set<ModifierKey>()
    
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
                    let activeModifiers = allModifiers.filter { flag in
                        event.modifierFlags.contains(flag)
                    }
                    modifierKeys = Set(activeModifiers.map { ModifierKey(modifier: $0) })
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
