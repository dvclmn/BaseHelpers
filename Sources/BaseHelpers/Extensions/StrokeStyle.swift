//
//  StrokeStyle.swift
//  Collection
//
//  Created by Dave Coleman on 16/11/2024.
//

import SwiftUI

public struct StrokeLighting: Sendable {
  public var lightDirection: Alignment = .top
  public var colour: Color = .white.opacity(0.1)
  public var thickness: CGFloat = 1.0
}


extension StrokeStyle {
  public static var simple01: StrokeStyle {
    .init(lineWidth: 1)
  }
  public static var simple02: StrokeStyle {
    .init(lineWidth: 2)
  }
  public static var simple03: StrokeStyle {
    .init(lineWidth: 3)
  }
  public static var simple04: StrokeStyle {
    .init(lineWidth: 4)
  }
  
  // MARK: - Dashed Stroke
  public static func dashed(
    strokeWidth: CGFloat,
    style: StrokeDashStyle = .dots,
    gap: CGFloat = 3,
  ) -> StrokeStyle {
    StrokeStyle(
      lineWidth: strokeWidth,
      lineCap: .round,
      lineJoin: .round,
      dash: [style.dashLength, strokeWidth * gap]
    )
  }
}

// MARK: - Manual Codable/Hashable implementation

extension StrokeStyle: @retroactive Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.lineWidth)
    hasher.combine(self.miterLimit)
    hasher.combine(self.dashPhase)
    hasher.combine(self.lineCap)
    hasher.combine(self.lineJoin)
    hasher.combine(self.dash.count)
    for v in self.dash { hasher.combine(v) }
  }
}
extension StrokeStyle: @retroactive Decodable {}
extension StrokeStyle: @retroactive Encodable {}
extension StrokeStyle {

  enum CodingKeys: String, CodingKey {
    case lineWidth
    case lineCap
    case lineJoin
    case miterLimit
    case dash
    case dashPhase
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(lineWidth, forKey: .lineWidth)
    try container.encode(lineCap.rawValue, forKey: .lineCap)
    try container.encode(lineJoin.rawValue, forKey: .lineJoin)
    try container.encode(miterLimit, forKey: .miterLimit)
    try container.encode(dash, forKey: .dash)
    try container.encode(dashPhase, forKey: .dashPhase)
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let lineWidth = try container.decode(CGFloat.self, forKey: .lineWidth)
    let lineCapRawValue = try container.decode(Int32.self, forKey: .lineCap)
    let lineJoinRawValue = try container.decode(Int32.self, forKey: .lineJoin)
    let miterLimit = try container.decode(CGFloat.self, forKey: .miterLimit)
    let dash = try container.decode([CGFloat].self, forKey: .dash)
    let dashPhase = try container.decode(CGFloat.self, forKey: .dashPhase)

    guard let lineCap = CGLineCap(rawValue: lineCapRawValue) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath + [CodingKeys.lineCap],
          debugDescription: "Invalid CGLineCap raw value: \(lineCapRawValue)"
        )
      )
    }

    guard let lineJoin = CGLineJoin(rawValue: lineJoinRawValue) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath + [CodingKeys.lineJoin],
          debugDescription: "Invalid CGLineJoin raw value: \(lineJoinRawValue)"
        )
      )
    }

    self.init(
      lineWidth: lineWidth,
      lineCap: lineCap,
      lineJoin: lineJoin,
      miterLimit: miterLimit,
      dash: dash,
      dashPhase: dashPhase
    )
  }

}
