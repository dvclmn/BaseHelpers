//
//  Theme+Shadow.swift
//  BoxCore
//
//  Created by Dave Coleman on 13/9/2024.
//


/// Thoughts for a parametric shadow system
///
/// - Any characters provided for any one parameter, will be cycled randomly
/// - There will be different classes of characters, that represent different
/// qualities, such as angle, orientation, opacity, etc
///
/// E.g. this `⣓` feels more anchored to the `bottomLeading` corner.
/// This `⡻` would be considered `topTrailing`.
///
/// - Define 3, maybe 4 levels of strength (opacity). Any more would cause
/// the shadow to take up too much room.
/// - Light source will (of course) determine the angle
/// - Hardness/spread — The gradient of the transition from fully black to full white
/// - Rounding? Fall-off? Not sure if this would be a result of hardness or not. But would
/// describe the sharpness/roundness of the corners of the shape formed overall by the shadow
///
/// ```
///    ░░░░░░░░░░░       ░░░░░░░░░░░░░░░░░
///  ░░▒▒▒▒▒▒▒▒▒▒▒░░     ░░▒▒▒▒▒▒▒▒▒▒▒▒▒░░
/// ░░▒▒┌───────┐▒▒░░    ░░▒▒┌───────┐▒▒░░
/// ░░▒▒│       │▒▒░░    ░░▒▒│       │▒▒░░
/// ░░▒▒│       │▒▒░░    ░░▒▒│       │▒▒░░
/// ░░▒▒└───────┘▒▒░░    ░░▒▒└───────┘▒▒░░
///  ░░▒▒▒▒▒▒▒▒▒▒▒░░     ░░▒▒▒▒▒▒▒▒▒▒▒▒▒░░
///    ░░░░░░░░░░░       ░░░░░░░░░░░░░░░░░
///
/// ```

public extension BoxCore.Theme {
  
  struct Shadow: Sendable {
    var type: ShadowType
    var lightSource: BoxCore.LightSource
    var strength: ShadowStrength
    
    public init(
      type: ShadowType = .simple,
      lightSource: BoxCore.LightSource = .topTrailing,
      strength: ShadowStrength = .light
    ) {
      self.type = type
      self.lightSource = lightSource
      self.strength = strength
    }
  }
}

public extension BoxCore.Theme.Shadow {
  
  /// What do we need to know to create a shadow for a side?
  ///
  /// 1. Dimensions — only 1x character high for text lines, but need
  /// height to make sure I match structural lines
  /// 2. Whether it repeats horizontally
  /// 3. Alignment based on light source
  ///
  
  
  /// Referring to horizontal space only
  ///
  var reservedSpace: Int {
    switch type {
      case .simple:
        1
      case .none:
        0
    }
  }
  

  
  enum ShadowType: Sendable {
    case simple
    case none
  } // END shadow type
  

  
  enum ShadowStrength: Sendable {
    case light
    case medium
    case dark
    
    public var character: Character {
      switch self {
        case .light:
          "░"
        case .medium:
          "▒"
        case .dark:
          "▓"
      }
    }
  }

}

public extension BoxCore {
  
  enum LightSource: Sendable {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    
    public func hasShadow(_ location: BoxCore.VerticalLocation) -> Bool {
      switch location {
        case .leading:
          self == .topLeading || self == .bottomLeading
        case .trailing:
          self == .topTrailing || self == .bottomTrailing
        case .interior:
          false
      }
    }
    
  } // END light source
}

