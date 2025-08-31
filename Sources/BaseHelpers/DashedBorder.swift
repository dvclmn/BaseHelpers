// The Swift Programming Language
// https://docs.swift.org/swift-book
//

//import SwiftUI
//
//public struct DashedBorder: ViewModifier {
//
//  var strokeColour: Color
//  var strokeWidth: Double
//
//  var dashLength: Double
//  var dashGap: Double
//
//  var rounding: Double
//
//
//  public func body(content: Content) -> some View {
//
//    content
//      .overlay {
//        RoundedRectangle(cornerRadius: rounding)
//          .strokeBorder(
//            strokeColour, style: StrokeStyle(lineWidth: strokeWidth, dash: [dashLength, dashGap]))
//      }
//  }
//
//}
//extension View {
//  public func dashedBorder(
//    strokeColour: Color = Color(.white),
//    strokeWidth: Double = 2,
//    dashLength: Double = 8,
//    dashGap: Double = 7,
//    rounding: Double = 14
//  ) -> some View {
//    self.modifier(
//      DashedBorder(
//        strokeColour: strokeColour,
//        strokeWidth: strokeWidth,
//        dashLength: dashLength,
//        dashGap: dashGap,
//        rounding: rounding
//      )
//    )
//  }
//}
