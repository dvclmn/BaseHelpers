//
//  Model+Effects.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

public struct OffsetEffect: AnimatableEffect {

  public static var kind: EffectKind { .offset }

  let width: CGFloat
  let height: CGFloat

  public init(
    w width: CGFloat = .zero,
    h height: CGFloat = .zero
  ) {
    self.width = width
    self.height = height
  }

  public init(fromValue value: CGSize) {
    self.init(w: value.width, h: value.height)
  }
}

extension OffsetEffect {
  public var intensity: CGSize { CGSize(width: width, height: height) }
  public var waveComposition: WaveComposition = .init()
  public func output(elapsed: CGFloat, waveLibrary: [Wave]) -> CGSize {
    let waveValue: CGFloat = waveComposition.value(
      elapsed: elapsed,
      waveLibrary: waveLibrary
    )
    let result = CGSize(width: width * waveValue, height: height * waveValue)
    return result
  }
}

