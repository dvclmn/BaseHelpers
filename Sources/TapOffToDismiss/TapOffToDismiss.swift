//
//  File.swift
//
//
//  Created by Dave Coleman on 4/7/2024.
//

import Foundation
import SwiftUI
import Dependencies
import Geometry
import BaseHelpers

#if os(macOS)

public struct TapOffToDismiss: ViewModifier {
  
  @Dependency(\.windowDimensions) var windowSize
  
  let action: () -> Void
  
  public func body(content: Content) -> some View {

      content
        .overlay {
          Color.clear
//          Color.blue.opacity(0.1)
          //              .ignoresSafeArea()
            .frame(width: windowSize.size.width, height: windowSize.size.height)
            .contentShape(Rectangle())
            .onTapGesture {
              action()
            }
            .onExitCommand {
              action()
            }
        } // END overlay
//        .task {
//          print("Window size: \(windowSize.size.width) x \(windowSize.size.height)")
//        }
  }
}
public extension View {
  func tapOffToDismiss(action: @escaping () -> Void) -> some View {
    self.modifier(
      TapOffToDismiss(action: action)
    )
  }
}
#endif



//struct TapOffExampleView: View {
//  
//  @State private var background: Color = .red
//  
//  var body: some View {
//    
//    VStack {
//      Text("Hello")
//        .tapOffToDismiss {
//          //          background = Color.random
//          print("Tapped")
//        }
//    }
//    
//    .padding(40)
//    .frame(width: 600, height: 700)
//    .background(background.opacity(0.2))
//    
//  }
//}
//#Preview {
//  TapOffExampleView()
//}
//

