//
//  VersionCheck.swift
//  Collection
//
//  Created by Dave Coleman on 5/10/2024.
//

import SwiftUI

public enum OSVersion {
  case macOS15
  case macOS14
  
  //  var available: String {
  //    switch self {
  //      case .macOS15:
  //        "macOS 15.0, *"
  //      case .macOS14:
  //        "macOS 14.0, *"
  //    }
  //  }
}

//public struct ExampleModifier: ViewModifier {
//
////  var osVersion: OSVersion
//  var content: Content
//
//  public init(
////    osVersion: OSVersion = .macOS15,
//    @ViewBuilder content: () -> Content
//  ) {
////    self.osVersion = osVersion
//    self.content = content()
//  }
//
//  public func body(content: Content) -> some View {
//
////    switch osVersion {
////      case .macOS15:
//        if #available(macOS 15.0, *) {
//          content
//        } else {
//          content
//        }
////      case .macOS14:
//
////    }
//
//    content
//
//  }
//}
//public extension View {
//  func example(
//    opacity: Double = 0.4
//  ) -> some View {
//    self.modifier(
//      ExampleModifier(
//        opacity: opacity
//      )
//    )
//  }
//}


//public struct PointerModifier: ViewModifier{
//  
//  public enum Style {
//    case standard
//    case grabActive
//    case zoomIn
//    case zoomOut
//  }
//  
//  var style: PointerModifier.Style
//  
//  public func body(content: Content) -> some View {
//    
//    if #available(macOS 15.0, *){
//      
//      switch style {
//        case .standard:
//          content.pointerStyle(.default)
//          
//        case .grabActive:
//          content.pointerStyle(.grabActive)
//          
//        case .zoomIn:
//          content.pointerStyle(.zoomIn)
//          
//        case .zoomOut:
//          content.pointerStyle(.zoomOut)
//      }
//      
//    } else {
//      content
//    }
//  }
//}
//
//public extension View{
//  func customPointer(_ style: PointerModifier.Style) -> some View{
//    modifier(PointerModifier(style: style))
//  }
//}

//public extension View {
//  /// Applies the given transform if the given condition evaluates to `true`.
//  /// - Parameters:
//  ///   - condition: The condition to evaluate.
//  ///   - transform: The transform to apply to the source `View`.
//  /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
//  @ViewBuilder func ifOSVersion<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
//    if condition {
//      transform(self)
//    } else {
//      self
//    }
//  }
//}
//
//public extension Bool {
//  
//  static var macOS15: Bool {
//    guard #available(macOS 15, *) else {
//      return false
//    }
//    return true
//  }
//}
