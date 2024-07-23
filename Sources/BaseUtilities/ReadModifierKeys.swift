//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI

public protocol ModifierKeyCollection {
    func holding(_ modifiers: NSEvent.ModifierFlags...) -> Bool
    func holding(_ modifiers: [NSEvent.ModifierFlags]) -> Bool
}

extension Array: ModifierKeyCollection where Element == ModifierKey {
    public func holding(_ modifiers: NSEvent.ModifierFlags...) -> Bool {
        holding(modifiers)
    }
    
    public func holding(_ modifiers: [NSEvent.ModifierFlags]) -> Bool {
        modifiers.allSatisfy { modifier in
            self.contains { $0.modifier == modifier }
        }
    }
}

extension Array where Element == ModifierKey {
    public func holding(_ modifier: NSEvent.ModifierFlags) -> Bool {
        contains { $0.modifier == modifier }
    }
}

extension NSEvent.ModifierFlags: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}




public struct ModifierKey: Sendable, Identifiable {
    public var id: UInt {
        self.modifier.rawValue
    }
    public var modifier: NSEvent.ModifierFlags
    public var name: String
}

public struct ModifierKeysKey: EnvironmentKey {
    public static let defaultValue: [ModifierKey] = []
}

public extension EnvironmentValues {
    var modifierKeys: [ModifierKey] {
        get { self[ModifierKeysKey.self] }
        set { self[ModifierKeysKey.self] = newValue }
    }
}

public struct ModifierKeysModifier: ViewModifier {
    @State private var modifierKeys: [ModifierKey] = []
    
    private let allModifiers: [(NSEvent.ModifierFlags, String)] = [
        (.shift, "Shift"),
        (.control, "Control"),
        (.option, "Option"),
        (.command, "Command")
    ]
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
                    
                    let activeModifiers = allModifiers.compactMap { (flag, name) in
                        event.modifierFlags.contains(flag) ? ModifierKey(modifier: flag, name: name) : nil
                    }
                    modifierKeys = activeModifiers
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
