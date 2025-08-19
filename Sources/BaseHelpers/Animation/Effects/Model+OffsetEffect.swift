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

  public var waveComposition: WaveComposition = .empty

}

extension OffsetEffect {
  
}

