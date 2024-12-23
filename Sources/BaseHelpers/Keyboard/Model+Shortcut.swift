//
//  Models.swift
//  Helpers
//
//  Created by Dave Coleman on 8/9/2024.
//
//
//#if canImport(AppKit)
//
//import SwiftUI
//
///// SwiftUI uses: `KeyboardShortcut`
//
//// MARK: - Main Shortcut model
//public struct KBShortcut: Equatable, Sendable {
//  public let key: KBShortcut.Key
//  public let modifiers: [KBShortcut.Modifier]
//  public let label: KBShortcut.Label?
//  
//  public init(
//    _ key: KBShortcut.Key,
//    modifiers: [KBShortcut.Modifier] = [],
//    label: Label? = nil
//  ) {
//    self.key = key
//    self.modifiers = modifiers
//    self.label = label
//  }
//  
//  /// AppKit init
//  public init(
//    _ key: KBShortcut.Key,
//    modifierFlags: NSEvent.ModifierFlags,
//    label: KBShortcut.Label? = nil
//  ) {
//    self.key = key
//    self.modifiers = KBShortcut.Modifier.from(modifierFlags)
//    self.label = label
//  }
//}
//
//
//public extension KBShortcut {
//  struct Label: Equatable, Sendable {
//    public var title: String
//    public var icon: String
//    
//    public init(
//      title: String,
//      icon: String
//    ) {
//      self.title = title
//      self.icon = icon
//    }
//  }
//}
//
//public extension KBShortcut {
//  
//  enum KeyType {
//    case key
//    case modifier
//  }
//  
//  protocol ShortcutKey: Equatable, Sendable, Identifiable {
//    
//    var id: String { get }
//    
//    /// E.g. `Delete` or `Control`
//    var name: String { get }
//    
//    /// E.g. `delete.backward` or `control`
//    var symbolName: String { get }
//    
//    /// E.g. `􁂈` or `􀆍`
//    var symbolLiteral: Character { get }
//    
//    var type: KeyType { get }
//  }
//}
//
//public extension KBShortcut.ShortcutKey {
//  var id: String { symbolName }
//}
//
//extension KBShortcut: CustomStringConvertible {
//  
//  public var description: String {
//    
//    let key = self.key.name.uppercased()
//    let modifierLiterals = self.modifiers.summarise(key: \.symbolLiteral, delimiter: nil)
//    let modifierNames = self.modifiers.summarise(key: \.symbolName)
//    
//    let result: String = """
//    
//    \(modifierLiterals)\(key)
//    Shortcut(
//      key: \(key), 
//      modifiers: \(modifierNames)
//    )
//    """
//    
//    return result
//  }
//}



//struct ShortcutDescriptionsView: View {
//  
//  let modifierList: [KBShortcut.Modifier] = KBShortcut.Modifier.allCases
//  let shortKeyList: [KBShortcut.Key] = KBShortcut.Key.allCases
//  
//  let columns: [GridItem] = Array(
//    repeating: GridItem(
//      .flexible(),
//      spacing: 20
//    ),
//    count: 3
//  )
//  
//  var body: some View {
//    
//    
//    LazyVGrid(columns: columns) {
//      ForEach(modifierList) { modifier in
//        
//        ShortcutPreview(
//          symbolLiteral: modifier.symbolLiteral,
//          name: modifier.name
//        )
//        
//      }
//      ForEach(shortKeyList) { key in
//        ShortcutPreview(
//          symbolLiteral: key.symbolLiteral,
//          name: key.name
//        )
//      }
//    } // END grid
//    .padding(40)
//    .frame(width: 400, height: 700)
//    .background(.black.opacity(0.6))
//    
//  }
//}
//
//extension ShortcutDescriptionsView {
//  
//  @ViewBuilder
//  func ShortcutPreview(
//    symbolLiteral: Character,
//    name: String
//  ) -> some View {
//    
//    VStack(spacing: 20) {
//      Text("\(symbolLiteral)")
//        .font(.title2)
//      Text(name)
//        .foregroundStyle(.secondary)
//    }
//    .frame(width: 110, height: 80)
//  }
//}
//
//#if DEBUG
//#Preview {
//  ShortcutDescriptionsView()
//}
//#endif



//extension Keyboard {
//
//  public struct Modifiers: OptionSet, Sendable {
//    public let rawValue: Int
//
//    public init(rawValue: Int) {
//      self.rawValue = rawValue
//    }
//
//    public static let command = Modifiers(rawValue: 1 << 0)
//    public static let option = Modifiers(rawValue: 1 << 1)
//    public static let control = Modifiers(rawValue: 1 << 2)
//    public static let shift = Modifiers(rawValue: 1 << 3)
//
//
//    var swiftUIModifiers: SwiftUI.EventModifiers {
//      var modifiers: SwiftUI.EventModifiers = []
//      if contains(.command) { modifiers.insert(.command) }
//      if contains(.option) { modifiers.insert(.option) }
//      if contains(.control) { modifiers.insert(.control) }
//      if contains(.shift) { modifiers.insert(.shift) }
//      return modifiers
//    }
//
//    var appKitModifiers: NSEvent.ModifierFlags {
//      var modifiers: NSEvent.ModifierFlags = []
//      if contains(.command) { modifiers.insert(.command) }
//      if contains(.option) { modifiers.insert(.option) }
//      if contains(.control) { modifiers.insert(.control) }
//      if contains(.shift) { modifiers.insert(.shift) }
//      return modifiers
//    }
//
//  }
//
//}
//
//#endif
