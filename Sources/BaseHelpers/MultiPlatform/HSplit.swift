//
//  HSplit.swift
//  Collection
//
//  Created by Dave Coleman on 14/11/2024.
//

import SwiftUI
//
//public struct HSplit<Content: View>: View {
//  
//  let content: Content
//  
//  public init(@ViewBuilder content: @escaping () -> Content) {
//    self.content = content()
//  }
//  
//  public var body: some View {
//#if canImport(AppKit)
//    HSplitView {
//      content
//    }
//#elseif canImport(UIKit)
//    HStack {
//      content
//    }
//#endif
//  }
//}


//#if os(macOS)
//struct HSplit<Content: View>: View {
//  let content: Content
//  
//  init(@ViewBuilder content: () -> Content) {
//    self.content = content()
//  }
//  
//  var body: some View {
//    HSplitView {
//      content
//    }
//  }
//}
//#else
//struct HSplit<Content: View>: View {
//  let content: Content
//  
//  init(@ViewBuilder content: () -> Content) {
//    self.content = content()
//  }
//  
//  var body: some View {
//    HStack {
//      content
//    }
//  }
//}
//#endif
