//
//  UnifiedDebugText.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 13/8/2025.
//

import SwiftUI

public typealias DebugTextList = [String]
public struct DebugTextKey: PreferenceKey {
  
  public static let defaultValue: DebugTextList = []
  
  public static func reduce(value: inout DebugTextList, nextValue: () -> DebugTextList) {
    let new = nextValue()
//    guard !new.isEmpty, !value.contains(new) else { return }
//    value.insert(new)
  }
}

extension View {
  public func addDebugText(_ debugText: String...) -> some View {
    return self.preference(key: DebugTextKey.self, value: debugText)
  }
}

public struct DebugText: View {
  
  @State private var textList: DebugTextList = []
  public var body: some View {
    VStack {
      ForEach(textList) { item in
        Text(item)
      }
    }
    .modifier(DebugTextStyleModifier())
    .onPreferenceChange(DebugTextKey.self) { newItems in
      updateIfChanged(newItems, into: &text)
    }
    
  }
}
