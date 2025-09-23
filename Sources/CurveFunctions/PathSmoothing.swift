//
//  PathSmoothing.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation

/// Not currently used by Animation Playground,
/// but seems handy enough to keep around
public enum PathSmoothing: WaveBase, CaseIterable, Identifiable {
  public static let allCases: [PathSmoothing] = [
    .linear,
    .quadCurve,
    .catmullRom(),
  ]

  case linear
  case quadCurve
  case catmullRom(CatmullRomConfiguration = .standard)

  public var id: String {
    self.name
  }

  public var name: String {
    switch self {
      case .linear:
        return "Linear"
      case .quadCurve:
        return "Quadratic"
      case .catmullRom:
        return "Catmull-Rom"
    }
  }
}

public struct CatmullRomConfiguration: WaveBase {
  let tension: CGFloat
  let alpha: CGFloat  // Future: centripetal/chordal parameterization
  //  var endpointHandling: EndpointHandling = .clamp
  public init(
    tension: CGFloat = 0.5,
    alpha: CGFloat = 0.5
  ) {
    self.tension = tension
    self.alpha = alpha
  }
  public static let standard = CatmullRomConfiguration()
}
