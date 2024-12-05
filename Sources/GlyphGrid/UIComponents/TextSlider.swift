////
////  TextSlider.swift
////  DrawString
////
////  Created by Dave Coleman on 27/8/2024.
////
//
//import SwiftUI
//
//struct TextSlider: View {
//
//  typealias Output = (CGFloat) -> Void
//
//  @Binding var value: CGFloat
//  let range: ClosedRange<Double>
//  let width: Int
//  let cellSize: CGSize
//  let onChanged: Output
//  let onEnded: Output
//
//  @State private var isDragging = false
//  @State private var dragStartLocation: CGPoint?
//
//  //  @State private var sliderDimensions: CGSize = .defaultCellSize
//
//  private let cellCharacters = ["░", "▒", "▓", "█"]
//
//  init(
//    value: Binding<CGFloat>,
//    range: ClosedRange<Double>,
//    width: Int,
//    cellSize: CGSize,
//    onChanged: @escaping Output = { _ in },
//    onEnded: @escaping Output = { _ in }
//  ) {
//    self._value = value
//    self.range = range
//    self.width = width
//    self.cellSize = cellSize
//    self.onChanged = onChanged
//    self.onEnded = onEnded
//  }
//
//  var body: some View {
//
//    VStack(spacing: 0) {
//      Text(sliderRepresentation())
//        .gridFont(for: .interface)
//        .gesture(
//          DragGesture(minimumDistance: 0)
//            .onChanged { gesture in
//              if !isDragging {
//                isDragging = true
//                dragStartLocation = gesture.startLocation
//                value = calculateValue(at: gesture.location, along: sliderTrackWidth)
//              } else {
//                value = calculateValue(at: gesture.location, along: sliderTrackWidth)
//                onChanged(value)
//              }
//            }
//            .onEnded { gesture in
//              isDragging = false
//              dragStartLocation = nil
//
//              let finalValue = calculateValue(at: gesture.location, along: sliderTrackWidth)
//              onEnded(finalValue)
//            }
//        )
//    }
//    .frame(width: sliderFullWidth)
//  }
//}
//
//extension TextSlider {
//  
//  var sliderTrackWidth: CGFloat {
//    CGFloat(sliderTrackColumns) * self.cellSize.width
//  }
//  
//  var sliderTrackColumns: Int {
//    width - 2
//  }
//
//  var sliderFullWidth: CGFloat {
//    CGFloat(self.width) * self.cellSize.width
//  }
//
//  private func sliderRepresentation() -> String {
//
//    let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
//    let filledWidth = Int(normalizedValue * Double(sliderTrackColumns))
//    let subCellPosition = (normalizedValue * Double(sliderTrackColumns) - Double(filledWidth)) * 4
//
//    var representation = "┌" + String(repeating: "─", count: sliderTrackColumns) + "┐\n│"
//
//    for i in 0 ..< sliderTrackColumns {
//      if i < filledWidth {
//        representation += "█"
//      } else if i == filledWidth {
//        representation += cellCharacters[min(Int(subCellPosition), 3)]
//      } else {
//        representation += " "
//      }
//    }
//
//    representation += "│\n└" + String(repeating: "─", count: sliderTrackColumns) + "┘\n"
//
////    if representation.count > width {
////      fatalError("`representation.count` ( \(representation.count) ) can't exceed containing width of \(width)")
////    }
//    
//    return representation
//  }
//
//  private func calculateValue(at location: CGPoint, along width: CGFloat) -> CGFloat {
//
//    let normalizedX = max(0.01, min(location.x, width)) / width
//
//    return range.lowerBound + (range.upperBound - range.lowerBound) * Double(normalizedX)
//
//  }
//}
