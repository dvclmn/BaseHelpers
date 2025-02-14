//
//  PreviewableSheet.swift
//  Collection
//
//  Created by Dave Coleman on 23/9/2024.
//
//
//import SwiftUI
//
//public struct PreviewableSheet<SheetContent: View>: ViewModifier {
//
//  @Binding var isPresented: Bool
//  let sheetContent: SheetContent
//
//  public init(
//    _ isPresented: Binding<Bool>,
//    @ViewBuilder sheetContent: () -> SheetContent
//  ) {
//    self._isPresented = isPresented
//    self.sheetContent = sheetContent()
//  }
//
//  public func body(content: Content) -> some View {
//
//    if isPreview {
//      if isPresented {
//        ZStack {
//          content
//          Color.black.opacity(0.4)
//          sheetContent
//        }
//        .overlay(alignment: .topLeading) {
//          Button {
//            isPresented = false
//          } label: {
//            Label("Hide sheet", systemImage: "eye")
//              .labelStyle(.titleOnly)
//          }
//        }
//      } else {
//        content
//      }
//    } else {
//      content
//      .sheet(isPresented: $isPresented) {
//        sheetContent
//      }
//      
//    }
//  }
//}
//public extension View {
//  func sheetWithPreview<Content: View>(
//    isPresented: Binding<Bool>,
//    @ViewBuilder content: () -> Content
//  ) -> some View {
//    self.modifier(PreviewableSheet(
//      isPresented,
//      sheetContent: content
//    ))
//  }
//}
