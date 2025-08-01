//
//  FrameFromUnitPointModifier.swift
//  BaseComponents
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

public struct HitAreaRect: View {

  let unitPoint: UnitPoint
  let thickness: CGFloat
  let offset: RectBoundaryPlacement
  let colour: Color
  let excludingCorners: Bool

  public init(
    unitPoint: UnitPoint,
    thickness: CGFloat,
    offset: RectBoundaryPlacement = .centre,
    colour: Color = .blue,
    excludingCorners: Bool
  ) {
    self.unitPoint = unitPoint
    self.thickness = thickness
    self.offset = offset
    self.colour = colour
    self.excludingCorners = excludingCorners
  }

  public var body: some View {
    //    ZStack {
    //
    //    }
    Rectangle()
      .fill(.clear)
      .frame(
        maxWidth: layout.fillSize.width,
        maxHeight: layout.fillSize.height
      )
      .padding(layout.edgePadding)

      .background(colour)
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: layout.alignment
      )
      .offset(rectOffset)
  }
}
extension HitAreaRect {

  var rectOffset: CGSize {
    switch offset {

      case .inside:
        return unitPoint.offset(by: thickness / 2)

      case .outside:
        return unitPoint.offset(by: -thickness)

      /// I think this is default behaviour
      case .centre: return .zero

    }
  }

  var layout: HitAreaLayout {
    return HitAreaLayout(
      from: unitPoint,
      thickness: thickness,
      excludingCorners: excludingCorners
    )
  }
}
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
