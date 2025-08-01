//
//  FrameFromUnitPointModifier.swift
//  BaseComponents
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

public struct HitAreaRectModifier: ViewModifier {

  @State private var isHovering: Bool = false

  private let offset: RectBoundaryPlacement = .outside
  //  private let corners: HitAreaCorner = .

  let unitPoint: UnitPoint
  let size: CGSize
  //  let thickness: CGFloat
  //  let cornerSize: CGSize
  let colour: Color
  let onTap: () -> Void

  /// Let's make an assumption for simplicity;
  /// Corners with a fixed Size, and Outside
  /// boundary placment
  //  let corners: HitAreaCorner
  //  let offset: RectBoundaryPlacement

  public func body(content: Content) -> some View {
    content
      .overlay(alignment: unitPoint.toAlignment) {
        Rectangle()
          .fill(.clear)
          .frame(
            maxWidth: layout.fillSize.width,
            maxHeight: layout.fillSize.height
          )
          .padding(layout.edgePadding)

          .background(isHovering ? colour.midOpacity : .clear)
          .border(isHovering ? colour : .clear)

          .onHover { hovering in
            isHovering = hovering
          }
          .simultaneousGesture(
            TapGesture()
              .onEnded { _ in
                if isHovering {
                  onTap()
                }
              }
          )
          //          .onTapGesture {
          //            onTap()
          //          }
          .offset(rectOffset)
      }
  }
}
extension HitAreaRectModifier {

  var thickness: CGFloat {
    unitPoint.valueFromSize(
      size,
      fallBackIfCorner: .width
    )
  }

  var rectOffset: CGSize {

    switch offset {

      case .inside:
        return unitPoint.offset(by: thickness / 2)

      case .outside:
        guard unitPoint.isEdge else {
          return unitPoint.offset(
            dx: -thickness,
            dy: -(thickness * 2)
          )
          //          return unitPoint.offset(by: -(thickness * 2))
        }
        return unitPoint.offset(by: -thickness)

      /// I think this is default behaviour
      case .centre: return .zero

    }
  }

  var layout: HitAreaLayout {
    return HitAreaLayout(
      from: unitPoint,
      thickness: thickness,
      corners: .fixedSize(size)
    )
  }
}

extension View {
  public func hitAreaRect(
    unitPoint: UnitPoint,
    size: CGSize,
    //    thickness: CGFloat,
    //    cornerSize: CGSize,
    colour: Color = .blue,
    onTap: @escaping () -> Void
  ) -> some View {
    self.modifier(
      HitAreaRectModifier(
        unitPoint: unitPoint,
        size: size,
        //        thickness: thickness,
        //        cornerSize: cornerSize,
        colour: colour,
        onTap: onTap
      )
    )
  }
}

//public struct HitAreaRect: View {
//
//  let unitPoint: UnitPoint
//  let thickness: CGFloat
//  let offset: RectBoundaryPlacement
//  let colour: Color
//  let corners: HitAreaCorner
//
//  public init(
//    unitPoint: UnitPoint,
//    thickness: CGFloat,
//    offset: RectBoundaryPlacement = .centre,
//    colour: Color = .blue,
//    corners: HitAreaCorner
//  ) {
//    self.unitPoint = unitPoint
//    self.thickness = thickness
//    self.offset = offset
//    self.colour = colour
//    self.corners = corners
//  }
//
//  public var body: some View {
//
//    Rectangle()
//      .fill(.clear)
//      .frame(
//        maxWidth: layout.fillSize.width,
//        maxHeight: layout.fillSize.height
//      )
//      .padding(layout.edgePadding)
//
//      .background(colour)
//
////      .border(Color.red.opacity(0.3))
//
//      //      .alignmentGuide(unitPoint.toAlignment.horizontal) { dimensions in
//      //        guard let value = unitPoint.valueFromViewDimensions(dimensions: dimensions) else { return .zero }
//      //        return value * 2
//      //      }
//      //      .alignmentGuide(unitPoint.toAlignment.vertical) { dimensions in
//      //        switch unitPoint.pointType {
//      //          case .horizontalEdge:
//      //            guard let value = unitPoint.valueFromViewDimensions(dimensions: dimensions) else { return .zero }
//      //            return value / 2
//      //          case .verticalEdge:
//      //            return .zero
//      //          case .corner:
//      //            return -200
//      //          case .centre:
//      //            return .zero
//      //        }
//      ////        guard let value = unitPoint.valueFromViewDimensions(dimensions: dimensions) else { return .zero }
//      ////        return value * 2
//      //      }
//      .frame(
//        maxWidth: .infinity,
//        maxHeight: .infinity,
//        alignment: layout.alignment
//      )
//      .offset(rectOffset)
//  }
//}

//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//  BoxPrintView()
//}
//#endif

//public struct HitAreaRectModifier: ViewModifier {
//
//  let unitPoint: UnitPoint
//  let thickness: CGFloat
//  let offset: RectBoundaryPlacement
//  let colour: Color
//
//  public func body(content: Content) -> some View {
//    content
//      .frame(
//        maxWidth: layout.fillSize.width,
//        maxHeight: layout.fillSize.height
//      )
//      .padding(layout.edgePadding)
//
//      .background(colour)
//      .frame(
//        maxWidth: .infinity,
//        maxHeight: .infinity,
//        alignment: layout.alignment
//      )
//      .offset(rectOffset)
//  }
//}

//extension View {
//
//  public func hitAreaRect(
//    unitPoint: UnitPoint,
//    thickness: CGFloat,
//    offset: RectBoundaryPlacement = .centre,
//    colour: Color = .blue
//  ) -> some View {
//    self.modifier(
//      HitAreaRectModifier(
//        unitPoint: unitPoint,
//        thickness: thickness,
//        offset: offset,
//        colour: colour
//      )
//    )
//  }
//}

//public struct HitAreaRect<Content: View>: View {
//
//  let unitPoint: UnitPoint
//  let thickness: CGFloat
//  let offset: RectBoundaryPlacement
//  let colour: Color
//
//  let content: Content
//
//  public init(
//    @ViewBuilder content: @escaping () -> Content
//  ) {
//    self.content = content()
//  }
//
//  public var body: some View {
//    content
//      .frame(
//        maxWidth: layout.fillSize.width,
//        maxHeight: layout.fillSize.height
//      )
//      .padding(layout.edgePadding)
//    //      .frame(
//    //        width: hitArea.size.width,
//    //        height: hitArea.size.height
//    //      )
//      .background(colour)
//      .frame(
//        maxWidth: .infinity,
//        maxHeight: .infinity,
//        alignment: layout.alignment
//      )
//      .offset(rectOffset)
//    //      .viewSize(mode: .noDebounce) { size in
//    //        containerSize = size
//    //      }
//  }
//}
//extension HitAreaRect {
//  var rectOffset: CGSize {
//    switch offset {
//
//      case .inside:
//        return unitPoint.offset(by: thickness / 2)
//
//      case .outside:
//        return unitPoint.offset(by: -thickness)
//
//        /// I think this is default behaviour
//      case .centre: return .zero
//
//    }
//  }
//
//  var layout: HitAreaLayout {
//    return HitAreaLayout(
//      from: unitPoint,
//      thickness: thickness
//    )
//  }
//}
