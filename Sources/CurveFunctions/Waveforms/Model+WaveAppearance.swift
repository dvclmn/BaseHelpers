//
//  Model+Wave.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 3/11/2024.
//

import SwiftUI

public struct WaveAppearance: WaveBase {
  let path: PathConfiguration
  let points: PointStyle
  let cyclesAcross: CGFloat

  static var windowOptions: [CGFloat] { [1, 2, 4, 8, 12, 24, 30] }
  static var timeRange: ClosedRange<CGFloat> { 1...30 }

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

public struct PathConfiguration: WaveBase {
  let lineWidth: CGFloat
//  let strokeStyle: StrokeStyle
//  let smoothing: PathSmoothing

  public init(
    lineWidth: CGFloat = 1
//    strokeStyle: StrokeStyle = .init(lineWidth: 1),
//    smoothing: PathSmoothing = .linear
  ) {
    self.lineWidth = lineWidth
//    self.strokeStyle = strokeStyle
//    self.smoothing = smoothing
  }
}

//extension StrokeStyle: @retroactive Hashable {
//  public func hash(into hasher: inout Hasher) {
//    <#code#>
//  }
//}
