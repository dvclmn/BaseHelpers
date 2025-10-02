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
