//
//  File.swift
//  
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI


#if os(macOS)

public struct EscapeKeyDoubleTapModifier: ViewModifier {
    var action: () -> Void
    var bufferMilliseconds: Int
    
    @State private var lastEscapePressDate: Date?

    public func body(content: Content) -> some View {
        content
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
                    self.handle(event: event)
                    return event
                }
            }
    }
    

    
    private func handle(event: NSEvent) {
        guard event.keyCode == 53 else {  // 53 is the keycode for Escape
            return
        }

        let now = Date()
        
        if let lastPress = lastEscapePressDate, now.timeIntervalSince(lastPress) * 1000 < Double(bufferMilliseconds) {
            action()
            lastEscapePressDate = nil // reset after action
        } else {
            lastEscapePressDate = now
        }
    }
}


public extension View {
    func onEscapeKeyDoubleTap(bufferMilliseconds: Int = 300, perform action: @escaping () -> Void) -> some View {
        self.modifier(EscapeKeyDoubleTapModifier(action: action, bufferMilliseconds: bufferMilliseconds))
    }
}


public protocol ModifierKeyCollection {
    func holding(_ modifiers: NSEvent.ModifierFlags...) -> Bool
    func holding(_ modifiers: [NSEvent.ModifierFlags]) -> Bool
}

//public extension Array where Element == ModifierKey {
//    func holding(_ modifiers: NSEvent.ModifierFlags...) -> Bool {
//        holding(modifiers)
//    }
//    
//    func holding(_ modifiers: [NSEvent.ModifierFlags]) -> Bool {
//        let activeModifiers = Set(self.map { $0.modifier })
//        return Set(modifiers).isSubset(of: activeModifiers)
//    }
//}
//
//public extension Array where Element == ModifierKey {
//    func holding(_ modifier: NSEvent.ModifierFlags) -> Bool {
//        contains { $0.modifier == modifier }
//    }
//}
//
extension NSEvent.ModifierFlags: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}



extension Set: ModifierKeyCollection where Element == NSEvent.ModifierFlags {
    public func holding(_ modifiers: NSEvent.ModifierFlags...) -> Bool {
        holding(modifiers)
    }
    
    public func holding(_ modifiers: [NSEvent.ModifierFlags]) -> Bool {
        modifiers.allSatisfy { self.contains($0) }
    }
}

extension Set where Element == NSEvent.ModifierFlags {
    public func holding(_ modifier: NSEvent.ModifierFlags) -> Bool {
        contains(modifier)
    }
}


public extension KeyboardShortcut {
    
    func printString(includesKeyLabel: Bool = false) -> String {
        
        var keyString: String {
            if let keySymbol = self.key.keyInfo() {
                let literal: String = keySymbol.symbolLiteral
                
                if includesKeyLabel, let label = keySymbol.label {
                    return literal + label
                } else {
                    return literal
                }
                
            } else {
                return self.key.character.description.uppercased()
            }
        }
        var modifierString: String {
            
            var modifiers: String = ""
            
            for string in self.modifiers.toModifierString(ofType: .literal) {
                modifiers += string
            }
            
            return modifiers
        }
        
        return modifierString + keyString
    }
}

public struct KeyInfo {
    public let label: String?
    public let symbolName: String
    public let symbolLiteral: String
}

public extension KeyEquivalent {
    
   
    func keyInfo() -> KeyInfo? {
        switch self {
        case .clear:
            return KeyInfo(label: "Clear", symbolName: "xmark", symbolLiteral: "􀆄")
        case .delete:
            return KeyInfo(label: "Delete", symbolName: "delete.backward", symbolLiteral: "􁂈")
        case .deleteForward:
            return KeyInfo(label: "Delete Forward", symbolName: "delete.forward", symbolLiteral: "􁂒")
        case .upArrow:
            return KeyInfo(label: "Up Arrow", symbolName: "arrowtriangle.up", symbolLiteral: "􀄤")
        case .downArrow:
            return KeyInfo(label: "Down Arrow", symbolName: "arrowtriangle.down", symbolLiteral: "􀄥")
        case .leftArrow:
            return KeyInfo(label: "Left Arrow", symbolName: "arrowtriangle.left", symbolLiteral: "􀄦")
        case .rightArrow:
            return KeyInfo(label: "Right Arrow", symbolName: "arrowtriangle.right", symbolLiteral: "􀰇")
        case .escape:
            return KeyInfo(label: "Escape", symbolName: "escape", symbolLiteral: "􀆧")
        case .home:
            return KeyInfo(label: "Home", symbolName: "arrow.up.left", symbolLiteral: "􀰹")
        case .end:
            return KeyInfo(label: "End", symbolName: "arrow.down.right", symbolLiteral: "􀱈")
        case .pageUp:
            return KeyInfo(label: "Page Up", symbolName: "arrow.up.to.line.compact", symbolLiteral: "􀅃")
        case .pageDown:
            return KeyInfo(label: "Page Down", symbolName: "arrow.down.to.line.compact", symbolLiteral: "􀅄")
        case .return:
            return KeyInfo(label: "Return", symbolName: "return", symbolLiteral: "􀅇")
        case .space:
            return KeyInfo(label: "Space", symbolName: "space", symbolLiteral: "􁁺")
        case .tab:
            return KeyInfo(label: "Tab", symbolName: "arrow.forward.to.line", symbolLiteral: "􁂎")
        default:
            return nil
        }
    }
    
}

public extension EventModifiers {
    
    struct ModifierInfo {
        let symbolName: String
        let symbolLiteral: String
    }
    
    enum ModifierSymbolType {
        case name
        case literal
    }
    
    private var relevantModifiers: [EventModifiers] {
        return [.shift, .option, .command, .capsLock, .control]
    }
    
    private var modifierInfo: ModifierInfo {
        switch self {
        case .shift:
            ModifierInfo(symbolName: "shift", symbolLiteral: "􀆝")
            
        case .option:
            ModifierInfo(symbolName: "option", symbolLiteral: "􀆕")
            
        case .command:
            ModifierInfo(symbolName: "command", symbolLiteral: "􀆔")
            
        case .capsLock:
            ModifierInfo(symbolName: "capslock", symbolLiteral: "􀆡")
            
        case .control:
            ModifierInfo(symbolName: "control", symbolLiteral: "􀆍")
            
        default:
            ModifierInfo(symbolName: "", symbolLiteral: "")
        }
    }
    
    func toModifierString(ofType type: ModifierSymbolType = .name) -> [String] {
        
        var modifierInfo = [String]()
        
        for modifier in relevantModifiers where self.contains(modifier) {
            switch type {
            case .name:
                modifierInfo.append(modifier.modifierInfo.symbolName)
            case .literal:
                modifierInfo.append(modifier.modifierInfo.symbolLiteral)
            }
        }
        
        return modifierInfo
    }
    
}

#endif
