//
//  Model+GeometryCapture.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 9/9/2025.
//

import SwiftUI

public protocol GeometryCapturable: Equatable, Sendable {}
extension CGSize: GeometryCapturable {}
extension CGRect: GeometryCapturable {}

public struct GeometryCapture<T: GeometryCapturable> {
  let type: T.Type
  let transform: @Sendable (GeometryProxy) -> T

  public init(
    type: T.Type,
    transform: @escaping @Sendable (GeometryProxy) -> T
  ) {
    self.type = type
    self.transform = transform
  }
}

extension GeometryCapture {
  public static var size: GeometryCapture<CGSize> {
    .init(type: CGSize.self) { $0.size }
  }

  public static var frameInScrollView: GeometryCapture<CGRect> {
    .init(type: CGRect.self) {
      $0.frame(in: .scrollView(axis: .vertical))
    }
  }
}

//enum GeometryCaptureKind {
//  case size
//  case frameInScrollView
//  
//  func capture<T: GeometryCapturable>() -> GeometryCapture<T> {
//    switch self {
//      case .size:
//        return GeometryCapture.size as! GeometryCapture<T>
//      case .frameInScrollView:
//        return GeometryCapture.frameInScrollView as! GeometryCapture<T>
//    }
//  }
//}

//
//public enum GeometryCapture {
//  case size
//  case frameInScrollView
//
//  var type: any GeometryCapturable.Type {
//    switch self {
//      case .size: CGSize.self
//      case .frameInScrollView: CGRect.self
//    }
//  }
//
//  func transform(proxy: GeometryProxy) -> any GeometryCapturable {
//    switch self {
//      case .size:
//        return proxy.size
//
//      case .frameInScrollView:
//        return proxy.frame(in: .scrollView(axis: .vertical))
//    }
//  }
//}
