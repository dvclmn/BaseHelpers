//
//  AnyShapeStyle.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/8/2025.
//

import SwiftUI

extension AnyShapeStyle {
  public static var clear: Self {
    Self(Color.clear)
  }
  
  public var opacityBarelyThere: Self { Self(opacity(OpacityPreset.opacityBarelyThere.rawValue)) }
  public var opacityFaint: Self { Self(opacity(OpacityPreset.opacityFaint.rawValue)) }
  public var opacityLow: Self { Self(opacity(OpacityPreset.opacityLow.rawValue)) }
  public var opacityMid: Self { Self(opacity(OpacityPreset.opacityMid.rawValue)) }
  public var opacityMedium: Self { Self(opacity(OpacityPreset.opacityMedium.rawValue)) }
  public var opacityHigh: Self { Self(opacity(OpacityPreset.opacityHigh.rawValue)) }
  public var opacityNearOpaque: Self { Self(opacity(OpacityPreset.opacityNearOpaque.rawValue)) }

}


