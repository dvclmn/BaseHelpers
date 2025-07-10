//
//  GraphicsContext.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

extension GraphicsContext {
  
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

