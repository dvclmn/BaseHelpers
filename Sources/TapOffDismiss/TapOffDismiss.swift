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

#if os(macOS)


public struct TapOffToDismiss: ViewModifier {
  
  @Dependency(\.windowDimensions) var windowSize
  
  let action: () -> Void
  
  public func body(content: Content) -> some View {
    
    ZStack {
      
      Color.blue.opacity(0.2)
        
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture {
          action()
        }
      
      
      content
        .onExitCommand {
          action()
        }
    }
    .frame(width: windowSize.size.width, height: windowSize.size.height)
    .ignoresSafeArea()
    .fixedSize(horizontal: true, vertical: true)
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
