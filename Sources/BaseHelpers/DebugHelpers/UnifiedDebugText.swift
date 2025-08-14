//
//  UnifiedDebugText.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 13/8/2025.
//

import SwiftUI

//public typealias DebugTextList = [String]
//public struct DebugTextKey: PreferenceKey {
//
//  public static let defaultValue: DebugTextList = []
//
//  public static func reduce(
//    value: inout DebugTextList,
//    nextValue: () -> DebugTextList
//  ) {
//    print("Updating reduce function. value: \(value). new: \(nextValue())")
//    for item in nextValue() {
//      value.append(item)
//    }
//
//    //    let newItems = nextValue().flatMap { item in
//    //      items
//    //    }
//
//    //    }
//  }
//}
//
//extension View {
//  public func debugTextEntry(_ debugText: DebugTextList) -> some View {
//    //  public func debugTextEntry(_ debugText: String...) -> some View {
//    return self.preference(key: DebugTextKey.self, value: debugText)
//  }
//}
//
//public struct DebugText: View {
//
//  @State private var textList: DebugTextList = []
//  public init() {}
//  public var body: some View {
//    VStack(alignment: .leading) {
//
//      if textList.isEmpty {
//        Text("No debug items")
//          .foregroundColor(.gray)
//          .italic()
//      } else {
//        ForEach(textList.indices, id: \.self) { index in
//          Text("• \(textList[index])")
//            .font(.caption)
//            .foregroundColor(.blue)
//        }
//      }
//
//      //      ForEach(textList, id: \.self) { item in
//      //        Text(item)
//      //      }
//    }
//    //    .modifier(DebugTextStyleModifier())
//    .padding()
//    .onPreferenceChange(DebugTextKey.self) { newItems in
//      print("DebugText received preference change: \(newItems)")  // Add logging
//      textList = newItems
//
//      //      updateIfChanged(newItems, into: &textList)
//    }
//
//  }
//}
