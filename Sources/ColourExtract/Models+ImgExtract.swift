//
//  Models+ImgExtract.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

/// A structure that represents a centroid.
public struct Centroid {
  /// The red channel value.
  var red: Float

  /// The green channel value.
  var green: Float

  /// The blue channel value.
  var blue: Float

  /// The number of pixels assigned to this cluster center.
  var pixelCount: Int = 0
}

/// A structure that represents a dominant color.
public struct DominantColor: Identifiable, Comparable {
  public var id = UUID()
  public let color: Color
  public let percentage: Int

  public init(
    _ centroid: Centroid,
    dimension: Int
  ) {
    self.color = Color(
      red: Double(centroid.red),
      green: Double(centroid.green),
      blue: Double(centroid.blue)
    )
    self.percentage = Int(Float(centroid.pixelCount) / Float(dimension * dimension) * 100)
  }

  public init(color: Color, percentage: Int) {
    self.color = color
    self.percentage = percentage
  }

  public static func < (lhs: DominantColor, rhs: DominantColor) -> Bool {
    return lhs.percentage < rhs.percentage
  }

  public static var zero: DominantColor {
    return DominantColor(color: .clear, percentage: 0)
  }
}

/// A structure that represents a thumbnail.
public struct Thumbnail: Identifiable, Hashable, Sendable {
  public var id = UUID()
  public let thumbnail: CGImage
}
