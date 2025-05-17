////
////  ExampleDragView.swift
////  BaseHelpers
////
////  Created by Dave Coleman on 16/5/2025.
////
//
//import SwiftUI
//
//public struct DragAxisDemoView: View {
//  @State private var value: Double = 50
//  @State private var isDragging: Bool = false
//  
//  public init() {
//
//  }
//
//  public var body: some View {
//    VStack(spacing: 20) {
//      Text("Current value: \(Int(value))")
//        .font(.headline)
//
//      // Simple slider with custom drag indicator
//      Rectangle()
//        .fill(Color.gray.opacity(0.2))
//        .frame(height: 30)
//        .cornerRadius(15)
//        .dragAlongAxis(
//          value: $value,
//          range: 0...100,
//          onDragChange: { dragging in
//            self.isDragging = dragging
//          },
//          dragContent: { value in
//            Circle()
//              .fill(Color.blue)
//              .frame(width: 30, height: 30)
//              .overlay(
//                Text("\(Int(value))")
//                  .foregroundColor(.white)
//                  .font(.caption)
//              )
//          }
//        )
//        .padding(.horizontal)
//
//      // Vertical slider example
//      Rectangle()
//        .fill(Color.gray.opacity(0.2))
//        .frame(width: 30, height: 200)
//        .cornerRadius(15)
//        .dragAlongAxis(
//          value: $value,
//          range: 0...100,
//          axis: .vertical,
//          dragContent: { value in
//            Circle()
//              .fill(Color.green)
//              .frame(width: 30, height: 30)
//          }
//        )
//
//      // Simple number field with drag to adjust
//      Text("Drag to adjust")
//        .padding()
//        .background(Color.blue.opacity(0.1))
//        .cornerRadius(8)
//        .dragAlongAxis(
//          value: $value,
//          range: 1...10
//        ) { someValue in
//          Text(someValue.displayString)
//        }
//      //        .dragAlongAxis(
//      //          value: $value,
//      //          range: 0...100,
//      //          minDragDistance: 0
//      //        )
//    }
//    .padding()
//  }
//}
//
//#if DEBUG
//#Preview {
//  DragAxisDemoView()
//}
//#endif
