//
//  FrameFromUnitPointModifier.swift
//  BaseComponents
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

public struct HitAreaRectModifier: ViewModifier {
  @State private var containerSize: CGSize = .zero

  let point: UnitPoint
  let thickness: CGFloat
  let colour: Color

  public func body(content: Content) -> some View {
    content
      .frame(width: hitArea.size.width, height: hitArea.size.height)
      .background(colour)
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: hitArea.alignment
      )
      .viewSize(mode: .noDebounce) { size in
        containerSize = size
      }
    //      )
  }
}
extension HitAreaRectModifier {
  var hitArea: HitAreaRect {
    return HitAreaRect(
      from: point,
      container: containerSize,
      thickness: thickness
    )
  }
}

extension View {

  public func hitAreaRect(
    unitPoint: UnitPoint,
    thickness: CGFloat,
    colour: Color = .blue
  ) -> some View {
    self.modifier(
      HitAreaRectModifier(
        point: unitPoint,
        thickness: thickness,
        colour: colour
      )
    )
  }

  //  public func boundaryRect(
  //    _ anchor: UnitPoint,
  //    width: DimensionLength,
  //    height: DimensionLength,
  //    colour: Color = .blue,
  //    corners: CornerResolutionStrategy
  //  ) -> some View {
  //    self.modifier(
  //      RectangleOverlayModifier(
  //        unitRect: UnitRect(
  //          anchor: anchor,
  //          width: width,
  //          height: height,
  //          cornerStrategy: corners
  //        ),
  //        colour: colour,
  //      )
  //    )
  //  }
}

//public struct UnitRectModifier: ViewModifier {
//
//  let point: UnitPoint
//  let fixedLength: CGFloat
//  let colour: Color
//  let opposingDimensionLength: OpposingDimensionLength
//  let corners: CornerStrategy
//
//  public func body(content: Content) -> some View {
//
//    content
//      .frame(
//        maxWidth: size.width,
//        maxHeight: size.height,
//      )
//
//      .background(colour)
//      //      .overlay {
//      //        DebugView()
//      //      }
//
//      .padding(.horizontal, paddingX)
//      .padding(.vertical, paddingY)
//
//      .frame(
//        maxWidth: .infinity,
//        maxHeight: .infinity,
//        alignment: point.toAlignment
//      )
//  }
//}
//
//extension UnitPointRectModifier {
//
//  /// Note: If corners are not required, padding is zero,
//  /// so that the rect can fill the provided dimension completely
//  var paddingX: CGFloat {
//    guard point.isHorizontalEdge else { return 0 }
//    return corners.shouldIncludeCorners ? (fixedLength / 2) : 0
//  }
//  var paddingY: CGFloat {
//    guard point.isVerticalEdge else { return 0 }
//    return corners.shouldIncludeCorners ? (fixedLength / 2) : 0
//  }
//
//  #warning("Temporaily in a WIP state")
//
//  var size: FrameDimensions {
//    point.boundarySize(
//      fixedLength: fixedLength,
//      opposingDimensionLength: opposingDimensionLength,
//      corners: .include
////      includeCorners: shouldGenerateCorners
//    )
//  }
//
//  @ViewBuilder
//  func DebugView() -> some View {
//    TextGroup(separator: "\n") {
//      Text("Point: \(point.name)")
//      Text("Width: \(size.width?.displayString ?? "nil")")
//      Text("Height: \(size.height?.displayString ?? "nil")")
//      Text("Alignment: \(point.toAlignment.displayName)")
//    }
//    .quickBackground()
//    .fixedSize()
//  }
//}

//extension View {
//
//#warning("Corner approach needs fixing up, WIP")
//  /// Use this overload when only a single value is needed for the
//  /// 'opposing' or fixed dimension. Regardless of edge/orientation (X or Y)
//  public func boundaryRect(
//    from unitPoint: UnitPoint,
//    withFixedLength fixedLength: CGFloat,
//    colour: Color,
//    opposingDimensionLength: OpposingDimensionLength = .zero,
//    shouldGenerateCorners: Bool = false
//  ) -> some View {
//    self.modifier(
//      UnitPointRectModifier(
//        point: unitPoint,
//        fixedLength: fixedLength,
//        colour: colour,
//        opposingDimensionLength: opposingDimensionLength,
//        corners: .include
////        shouldGenerateCorners: shouldGenerateCorners
//      )
//    )
//  }
//
//  /// Use this overload in cases where you want horizontal and vertical
//  /// orientations to use a different value, derived from the relevant
//  /// dimension from the provided `CGSize`.
//  public func boundaryRect(
//    from unitPoint: UnitPoint,
//    withFixedSize fixedSize: CGSize,
//    colour: Color,
//    opposingDimensionLength: OpposingDimensionLength = .zero,
//    shouldGenerateCorners: Bool = false
//  ) -> some View {
//    self.modifier(
//      UnitPointRectModifier(
//        point: unitPoint,
//        fixedLength: unitPoint.valueFromSize(size: fixedSize, fallBackIfCorner: .zero),
//        colour: colour,
//        opposingDimensionLength: opposingDimensionLength,
//        corners: .include
////        shouldGenerateCorners: shouldGenerateCorners
//      )
//    )
//  }
//}
