//
//  UnitPoint.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI


extension UnitPoint: @retroactive Identifiable {
  public var id: String { self.name }
}

extension UnitPoint {
  
//  public func startPoint(
//    for axis: Axis,
//    mapping: DimensionToAxisConvention
//  ) -> Self {
//
//  }
//  public func endPoint(
//    for axis: Axis,
//    mapping: DimensionToAxisConvention
//  ) -> Self {
//    switch mapping {
//      case .widthIsHorizontal: Self.trailing
//      case .heightIsHorizontal: Self.bottom
//    }
//  }

  public func toCGPoint(in size: CGSize) -> CGPoint {
    let result = CGPoint(
      x: self.x * size.width,
      y: self.y * size.height
    )
    return result

  }

  public static func location(
    for point: CGPoint,
    in size: CGSize
  ) -> UnitPoint {
    let result = UnitPoint(
      x: point.x / size.width,
      y: point.y / size.height
    )
    return result
  }

 

  // Corner intermediates (positioned between corners and edge centers)
  public static let topLeadingMid = UnitPoint(x: 0.25, y: 0.25)
  public static let topTrailingMid = UnitPoint(x: 0.75, y: 0.25)
  public static let bottomLeadingMid = UnitPoint(x: 0.25, y: 0.75)
  public static let bottomTrailingMid = UnitPoint(x: 0.75, y: 0.75)

  // Edge intermediates (positioned between edge centers and corners)
  public static let topMid = UnitPoint(x: 0.5, y: 0.25)
  public static let leadingMid = UnitPoint(x: 0.25, y: 0.5)
  public static let trailingMid = UnitPoint(x: 0.75, y: 0.5)
  public static let bottomMid = UnitPoint(x: 0.5, y: 0.75)

  // Quarter points along edges
  public static let topQuarter = UnitPoint(x: 0.25, y: 0.0)
  public static let topThreeQuarters = UnitPoint(x: 0.75, y: 0.0)
  public static let leadingQuarter = UnitPoint(x: 0.0, y: 0.25)
  public static let leadingThreeQuarters = UnitPoint(x: 0.0, y: 0.75)
  public static let trailingQuarter = UnitPoint(x: 1.0, y: 0.25)
  public static let trailingThreeQuarters = UnitPoint(x: 1.0, y: 0.75)
  public static let bottomQuarter = UnitPoint(x: 0.25, y: 1.0)
  public static let bottomThreeQuarters = UnitPoint(x: 0.75, y: 1.0)

  // Center region intermediates
  public static let centerLeading = UnitPoint(x: 0.25, y: 0.5)
  public static let centerTrailing = UnitPoint(x: 0.75, y: 0.5)
  public static let centerTop = UnitPoint(x: 0.5, y: 0.25)
  public static let centerBottom = UnitPoint(x: 0.5, y: 0.75)

  // Diagonal points
  public static let diagonalQuarter = UnitPoint(x: 0.25, y: 0.25)
  public static let diagonalThreeQuarters = UnitPoint(x: 0.75, y: 0.75)
  public static let diagonalInverseQuarter = UnitPoint(x: 0.25, y: 0.75)
  public static let diagonalInverseThreeQuarters = UnitPoint(x: 0.75, y: 0.25)

  public var opposing: UnitPoint {
    switch self {
      case .topLeading: .bottomTrailing
      case .top: .bottom
      case .topTrailing: .bottomLeading
      case .trailing: .leading
      case .bottomTrailing: .topLeading
      case .bottom: .top
      case .bottomLeading: .topTrailing
      case .leading: .trailing
      case .center: .center
      default: .center
    }
  }
  
  

  public var toAlignment: Alignment {

    switch self {

      case .topLeading: .topLeading
      case .top: .top
      case .topTrailing: .topTrailing
      case .trailing: .trailing
      case .bottomTrailing: .bottomTrailing
      case .bottom: .bottom
      case .bottomLeading: .bottomLeading
      case .leading: .leading
      case .center: .center
      default: .center
    }
  }

  public var name: String {
    switch self {
      case .topLeading: "Top Leading"
      case .top: "Top"
      case .topTrailing: "Top Trailing"
      case .trailing: "Trailing"
      case .bottomTrailing: "Bottom Trailing"
      case .bottom: "Bottom"
      case .bottomLeading: "Bottom Leading"
      case .leading: "Leading"
      case .center: "Center"
      default:
        "Unknown"
    }
  }

  public static var topRow: [UnitPoint] {
    [
      .topLeading,
      .top,
      .topTrailing,
    ]
  }

  public static var middleRow: [UnitPoint] {
    [
      .leading,
      .center,
      .trailing,
    ]
  }

  public static var bottomRow: [UnitPoint] {
    [
      .bottomLeading,
      .bottom,
      .bottomTrailing,
    ]
  }
  
  /// This is just for visual debugging
  public var debugColour: Color {
    switch self {
      case .topLeading: Color.red
      case .top: Color.blue
      case .topTrailing: Color.orange
      case .trailing: Color.brown
      case .bottomTrailing: Color.purple
      case .bottom: Color.mint
      case .bottomLeading: Color.cyan
      case .leading: Color.green
      case .center: Color.yellow
      default: Color.gray
    }
  }
}
