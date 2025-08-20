//
//  Angle.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

extension Angle {
  public static func * (lhs: Angle, rhs: CGFloat) -> Angle {
    Angle(radians: lhs.radians * Double(rhs))
  }
}

extension Angle: @retroactive Decodable {}
extension Angle: @retroactive Encodable {}

extension Angle {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(radians) // Always store radians for consistency
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let radians = try container.decode(Double.self)
    self.init(radians: radians)
  }
}
