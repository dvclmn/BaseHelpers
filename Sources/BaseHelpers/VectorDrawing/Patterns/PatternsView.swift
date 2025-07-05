//
//  Patterns.swift
//  Components
//
//  Created by Dave Coleman on 14/11/2024.
//

//#if canImport(AppKit)

import SwiftUI

public struct PatternPreset: Sendable {
  let style: PatternStyle
  let config: PatternConfiguration
}

extension PatternPreset {
  public static let opacityCheckerboard = PatternPreset(
    style: .checkerboard,
    config: PatternConfiguration(
      size: 5,
      gap: 2,
      offset: CGSize(width: 0, height: -2),
      primaryColour: RGBColour.grey,
      secondaryColour: RGBColour.white
    )
  )

}

public struct PatternCanvas: View {

  let style: PatternStyle
  let config: PatternConfiguration
  /// I'm not sure it makes sense to pass in size? Can this be inferred from
  /// just, how large the parent/calling view is?
  //  let viewSize: CGSize?

  public init(
    _ style: PatternStyle,
    config: PatternConfiguration = .init(),
  ) {
    self.style = style
    self.config = config
  }
  public init(
    preset: PatternPreset,
  ) {
    self.style = preset.style
    self.config = preset.config
  }

  public var body: some View {
    Canvas {
      context,
      size in
      context.drawPattern(style, in: size)
//      switch style {
//        case .checkerboard:
//          context.drawCheckerboard(
//            config: config,
//            size: size,
//            offset: config.offset
//          )
//
//        case .chevron:
//          context.drawChevron(config: config, size: size)
//
//        case .stitches:
//          context.drawStitches(config: config, size: size)
//
//        case .waves:
//          context.drawWaves(config: config, size: size)
//
//        case .stripes:
//          context.drawStripes(config: config, size: size)
//
//      }
    }
  }
}

extension PatternCanvas {

  public func patternColours(
    _ foreground: RGBColour = .greyDark,
    _ background: RGBColour = .white
  ) -> Self {
    let currentStyle = self.style
    var newConfig = self.config
    newConfig.primaryColour = foreground
    newConfig.secondaryColour = background
    return PatternCanvas(currentStyle, config: newConfig)
  }

  public func patternSize(_ size: CGFloat) -> Self {
    let currentStyle = self.style
    var newConfig = self.config
    newConfig.size = size
    return PatternCanvas(currentStyle, config: newConfig)
  }

  public func patternOffset(x: CGFloat = 0, y: CGFloat = 0) -> Self {
    let currentStyle = self.style
    var newConfig = self.config
    newConfig.offset = CGSize(width: x, height: y)
    return PatternCanvas(currentStyle, config: newConfig)
  }

  public func patternGap(_ gap: CGFloat) -> Self {
    let currentStyle = self.style
    var newConfig = self.config
    newConfig.gap = gap
    return PatternCanvas(currentStyle, config: newConfig)
  }

  public func patternSizeAndGap(_ size: CGFloat, _ gap: CGFloat) -> Self {
    let currentStyle = self.style
    var newConfig = self.config
    newConfig.size = size
    newConfig.gap = gap
    return PatternCanvas(currentStyle, config: newConfig)
  }
}
//#endif
