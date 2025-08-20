//
//  Model+Wave.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 3/11/2024.
//

import SwiftUI

public struct WaveAppearance: Documentable {
  let path: PathConfiguration
  let points: PointStyle
  let cyclesAcross: CGFloat

  static let windowOptions: [CGFloat] = [1, 2, 4, 8, 12, 24, 30]
  static let timeRange: ClosedRange<CGFloat> = 1...30

  public init(
    path: PathConfiguration = .init(),
    points: PointStyle = .init(),
    cyclesAcross: CGFloat = 2
  ) {
    self.path = path
    self.points = points
    self.cyclesAcross = cyclesAcross
  }
}

public struct PathConfiguration: Documentable {
  let strokeStyle: StrokeStyle
  let smoothing: PathSmoothing

  public init(
    strokeStyle: StrokeStyle = .simple01,
    smoothing: PathSmoothing = .linear
  ) {
    self.strokeStyle = strokeStyle
    self.smoothing = smoothing
  }
}

//extension StrokeStyle: @retroactive Hashable {
//  public func hash(into hasher: inout Hasher) {
//    <#code#>
//  }
//}
