//
//  KeyHeld.swift
//  Collection
//
//  Created by Dave Coleman on 6/12/2024.
//

#warning("Maybe I still need keysHeld, but I'm pretty sure keysPressed can be achieved just fine in native SwiftUI, using .keyboardShortcut(key: modifiers []) — ensuring that if no modifier key is needed, then using a *blank* with [], as the default is `.command`")
//#if canImport(AppKit)
//
//import SwiftUI
//
//public struct KeysPressedModifier: ViewModifier {
//
//  @State private var keyDownMonitor: Any?
//  @State private var keyUpMonitor: Any?
//  @State private var heldKeys: Set<KeyEquivalent> = []
//
//  let keys: Set<KeyEquivalent>
//  
//  /// Where the returned `Bool` means handled or not
//  let onPress: (KeyEquivalent) -> Void
////  let onPress: (KeyEquivalent) -> Bool
//  
//  let isHeld: (Set<KeyEquivalent>) -> Void
//
//  public func body(content: Content) -> some View {
//    content
//      .onAppear {
//        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
//          guard let character = event.characters?.lowercased().first,
//            let key = keys.first(where: { $0.character == character })
//          else {
//            return event
//          }
//          //          if !heldKeys.contains(key) {
//          heldKeys.insert(key)
//          isHeld(heldKeys)
//          onPress(key)
//          //          }
//
//          return nil
//        }
//
//        keyUpMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
//          guard let character = event.characters?.lowercased().first,
//            let key = keys.first(where: { $0.character == character })
//          else {
//            return event
//          }
//
//          heldKeys.remove(key)
//          isHeld(heldKeys)
//          return nil
//
//        }
//      }
//      .onDisappear {
//        if let down = keyDownMonitor {
//          NSEvent.removeMonitor(down)
//        }
//        if let up = keyUpMonitor {
//          NSEvent.removeMonitor(up)
//        }
//      }
//  }
//}
//
//// Usage example:
//extension View {
//  public func keysPressed(
//    _ keys: Set<KeyEquivalent>,
//    onPress: @escaping (KeyEquivalent) -> Void
//  ) -> some View {
//    self.modifier(
//      KeysPressedModifier(
//        keys: keys,
//        onPress: onPress,
//        isHeld: { _ in }
//      )
//    )
//  }
//
//  public func keysHeld(
//    _ keys: Set<KeyEquivalent>,
//    onPress: @escaping (KeyEquivalent) -> Void = { _ in },
//    isHeld: @escaping (Set<KeyEquivalent>) -> Void,
//  ) -> some View {
//    self.modifier(
//      KeysPressedModifier(
//        keys: keys,
//        onPress: onPress,
//        isHeld: isHeld
//      )
//    )
//  }
//
//}
//
//#endif
