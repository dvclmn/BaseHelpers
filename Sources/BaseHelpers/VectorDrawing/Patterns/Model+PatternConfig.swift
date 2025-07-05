//
//  Model+Patterns.swift
//  Components
//
//  Created by Dave Coleman on 19/11/2024.
//

import Foundation
import BaseHelpers
import BaseStyles
import CoreGraphics

public struct PatternConfiguration: Codable, Equatable, Hashable, Sendable {
  
  /// This is a generic reference to the 'main' quality of the pattern,
  /// that makes sense to receive a size. This is not an ideal pattern,
  /// and can afford to be improved upon
  var size: Double
  
  /// Again, a generic value for whatever most represents a 'gap',
  /// in the assigned `PatternStyle`
  var gap: Double
  var offset: CGSize
  
  var primaryColour: RGBColour
  var secondaryColour: RGBColour
  
  public init(
    size: Double = 30,
    gap: Double = 10,
    offset: CGSize = .zero,
    primaryColour: RGBColour = .greyDark,
    secondaryColour: RGBColour = .white
  ) {
    self.size = size
    self.gap = gap
    self.offset = offset
    self.primaryColour = primaryColour
    self.secondaryColour = secondaryColour
  }
}

extension PatternConfiguration {
  public static let checkboardExample = PatternConfiguration(
    size: 20,
    gap: 10,
    primaryColour: .greyDark,
    secondaryColour: .white
  )
}
