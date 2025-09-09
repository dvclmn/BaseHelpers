//
//  Model+GeometryCapture.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 9/9/2025.
//

import SwiftUI

protocol GeometryCapturable: Equatable, Sendable {}
extension CGSize: GeometryCapturable {}
extension CGRect: GeometryCapturable {}

public enum GeometryCapture {
  case size
  case frameInScrollView

  var type: any GeometryCapturable.Type {
    switch self {
      case .size: CGSize.self
      case .frameInScrollView: CGRect.self
    }
  }

  func transform(proxy: GeometryProxy) -> any GeometryCapturable {
    switch self {
      case .size:
        return proxy.size

      case .frameInScrollView:
        return proxy.frame(in: .scrollView(axis: .vertical))
    }
  }
}
