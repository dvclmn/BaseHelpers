//
//  UnifiedDebugText.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 13/8/2025.
//

import SwiftUI

public typealias DebugTextList = [String]
public struct DebugTextKey: PreferenceKey {

  public static let defaultValue: DebugTextList = ["No debug items"]

  public static func reduce(value: inout DebugTextList, nextValue: () -> DebugTextList) {
    for item in nextValue() where !value.contains(item) {
      value.append(item)
    }
  }
}

extension View {
  public func debugTextEntry(_ debugText: DebugTextList) -> some View {
    //  public func debugTextEntry(_ debugText: String...) -> some View {
    return self.preference(key: DebugTextKey.self, value: debugText)
  }
}

public struct DebugText: View {

  @State private var textList: DebugTextList = []
  public init() {}
  public var body: some View {
    VStack(alignment: .leading) {
      ForEach(textList, id: \.self) { item in
        Text(item)
      }
    }
    .modifier(DebugTextStyleModifier())
    .padding()
    .onPreferenceChange(DebugTextKey.self) { newItems in
      //      textList = newItems
      updateIfChanged(newItems, into: &textList)
    }

  }
}
