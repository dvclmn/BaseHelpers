//
//  File.swift
//
//
//  Created by Dave Coleman on 15/7/2024.
//

import Foundation
import SwiftUI

public struct TapToCopy: ViewModifier {
  
  var value: String
  
  public func body(content: Content) -> some View {
    content
      .onTapGesture {
        copyStringToClipboard(value)
      }
    
  }
}
public extension View {
  func tapToCopy(
    value: String
  ) -> some View {
    self.modifier(
      TapToCopy(
        value: value
      )
    )
  }
}
