//
//  GraphicsContext.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

extension GraphicsContext {
  
  public func drawCircle(
    at origin: CGPoint,
    size: CGFloat = 6,
    colour: Color = .blue
  ) {
    let circleOrigin = origin.shift(by: size / 2)
    let circleRect = CGRect(origin: circleOrigin , size: CGSize(fromLength: size))
    self.fill(.init(ellipseIn: circleRect), with: .color(colour))
  }
  
  public func fillAndStroke(
    _ path: Path,
    fillColour: Color,
    strokeColour: Color,
    strokeThickness: CGFloat = 1
  ) {
    
    self.fill(
      path,
      with: .color(fillColour)
    )
    self.stroke(
      path,
      with: .color(strokeColour),
      lineWidth: strokeThickness
    )
  }
  
  public func drawPattern(
    _ pattern: PatternStyle,
    config: PatternConfiguration = .default,
    in size: CGSize
  ) {
    switch pattern {
      case .checkerboard:
        return drawCheckerboard(
          config: config,
          size: size
        )
      case .chevron:
        return drawChevron(
          config: config,
          size: size
        )
        
      case .stitches:
        return drawStitches(
          config: config,
          size: size
        )
        
      case .waves:
        return drawWaves(
          config: config,
          size: size
        )
        
      case .stripes:
        return drawStripes(
          config: config,
          size: size
        )
        
    }
  }
  // MARK: - Path Debug
  public func debugPath(
    path: Path,
    config: PathDebugConfig = .init()
  ) {
    let debugPaths = PathAnalyser.analyse(path, config: config)
    
    self.stroke(
      debugPaths.original,
      with: .color(config.stroke.colour),
      lineWidth: config.stroke.width
    )
    self.stroke(
      debugPaths.connections,
      with: .color(config.controlPoint.guideColour),
      lineWidth: config.stroke.width
    )
    self.stroke(
      debugPaths.nodes,
      with: .color(config.node.colour),
      lineWidth: config.stroke.width
    )
    self.stroke(
      debugPaths.controlPoints,
      with: .color(config.controlPoint.colour),
      lineWidth: config.stroke.width
    )
  }

}


import SwiftUI

public struct GraphicContextPresetsView: View {
  
  @State private var selectedPreset: PatternStyle = .stitches
  
  public var body: some View {
    
    Canvas { context, size in
      context.drawPattern(selectedPreset, in: size)
    }
    .background(.blue.quinary)
//    .toolbar {
//      ToolbarItem {
//        Picker("Patterns", selection: $selectedPreset) {
//          Text("Checkerboard").tag(PatternStyle.checkerboard)
//          Text("Waves").tag(PatternStyle.waves)
////          ForEach(PatternStyle.allCases, id: \.self) { pattern in
////            Text(pattern.name).tag(pattern)
////          }
//        }
//        .pickerStyle(.segmented)
//      }
//    }
    
  }
}
#if DEBUG
#Preview {
  GraphicContextPresetsView()
}
#endif

