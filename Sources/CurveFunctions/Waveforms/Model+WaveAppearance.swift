//
//  Model+Wave.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 3/11/2024.
//

import SwiftUI

public struct WaveAppearance<T: CodableColour>: WaveBase {
  let path: PathConfiguration
  let points: PointStyle<T>
  let cyclesAcross: CGFloat

  static var windowOptions: [CGFloat] { [1, 2, 4, 8, 12, 24, 30] }
  static var timeRange: ClosedRange<CGFloat> { 1...30 }

  public init(
    path: PathConfiguration = .init(),
    points: PointStyle<T> = .init(),
    cyclesAcross: CGFloat = 2
  ) {
    self.path = path
    self.points = points
    self.cyclesAcross = cyclesAcross
  }
}

public struct PathConfiguration: WaveBase {
  let strokeStyle: StrokeStyle
  let smoothing: PathSmoothing

  public init(
    strokeStyle: StrokeStyle = .init(lineWidth: 1),
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
