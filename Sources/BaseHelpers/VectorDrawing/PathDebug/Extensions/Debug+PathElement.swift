//
//  Debug+PathElement.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

extension Path.Element {
  public var debugStyle: PointStyle {
    
    let size: PointSize = .normal
    return switch self {
      case .move:
        PointStyle(
          displayName: self.displayName,
          shape: .square,
          colour: .blue,
          size: size
        )
      case .line:
        PointStyle(
          displayName: self.displayName,
          shape: .square,
          colour: .cyan,
          size: size
        )
        
      case .quadCurve:
        PointStyle(
          displayName: self.displayName,
          shape: .circle,
          colour: .orange,
          size: size
        )
        
      case .curve:
        PointStyle(
          displayName: self.displayName,
          shape: .circle,
          colour: .brown,
          size: size
        )
        
      case .closeSubpath:
        PointStyle(
          displayName: self.displayName,
          shape: .circle,
          colour: .gray,
          size: size
        )
    }
    
  }
  
  //  public func addPoint(
  //    to path: inout Path,
  //    at point: CGPoint,
  //    size: PointSize
  //  ) {
  //
  //    //    let point = switch self {
  //    //      case .move(let to):
  //    //        <#code#>
  //    //      case .line(let to):
  //    //        <#code#>
  //    //      case .quadCurve(let to, let control):
  //    //        <#code#>
  //    //      case .curve(let to, let control1, let control2):
  //    //        <#code#>
  //    //      case .closeSubpath:
  //    //        <#code#>
  //    //    }
  //    //
  //    let pointSize = size.rawValue
  //    let style = self.debugStyle(size: size)
  //
  //    let rect = CGRect(
  //      x: point.x - pointSize / 2,
  //      y: point.y - pointSize / 2,
  //      width: pointSize,
  //      height: pointSize)
  //
  //    switch style.shape {
  //      case .circle:
  //        path.addEllipse(in: rect)
  //      case .square:
  //        path.addRect(rect)
  //    }
  //  }
  
  public var displayName: String {
    switch self {
      case .move(let point): "Move(\(point))"
      case .line(let point): "Line(\(point))"
      case .quadCurve(let point, let control): "QuadCurve(\(point),\(control))"
      case .curve(let point, let control1, let control2): "Curve(\(point),\(control1),\(control2))"
      case .closeSubpath: "Close"
    }
  }
  
}
