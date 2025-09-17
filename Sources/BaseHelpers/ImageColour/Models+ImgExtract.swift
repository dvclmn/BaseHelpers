//
//  Models+ImgExtract.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

/// A structure that represents a centroid.
struct Centroid {
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
struct DominantColor: Identifiable, Comparable {
  var id = UUID()
  let color: Color
  let percentage: Int

  init(_ centroid: Centroid, dimension: Int) {
    self.color = Color(
      red: Double(centroid.red),
      green: Double(centroid.green),
      blue: Double(centroid.blue)
    )
    self.percentage = Int(Float(centroid.pixelCount) / Float(dimension * dimension) * 100)
  }

  init(color: Color, percentage: Int) {
    self.color = color
    self.percentage = percentage
  }

  static func < (lhs: DominantColor, rhs: DominantColor) -> Bool {
    return lhs.percentage < rhs.percentage
  }

  static var zero: DominantColor {
    return DominantColor(color: .clear, percentage: 0)
  }
}

/// A structure that represents a thumbnail.
struct Thumbnail: Identifiable, Hashable, Sendable {
  var id = UUID()
  let thumbnail: CGImage
}
