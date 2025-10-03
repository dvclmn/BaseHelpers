//
//  Model+PanPhase.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import Foundation

public enum PanPhase {
  case inactive
  case active(delta: CGSize)
  case ended(finalDelta: CGSize)
  case cancelled
}
