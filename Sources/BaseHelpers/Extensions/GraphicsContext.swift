//
//  GraphicsContext.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

extension GraphicsContext {
  
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
        return drawCheckerboard(
          config: config,
          size: size
        )
        
      case .stitches:
        return drawCheckerboard(
          config: config,
          size: size
        )
        
      case .waves:
        return drawCheckerboard(
          config: config,
          size: size
        )
        
      case .stripes:
        return drawCheckerboard(
          config: config,
          size: size
        )
        
    }
  }

}


import SwiftUI

public struct GraphicContextPresetsView: View {
  
  @State private var selectedPreset: PatternStyle = .checkerboard
  
  public var body: some View {
    
    Canvas { context, size in
      context.drawPattern(selectedPreset, in: size)
    }
    .toolbar {
//      ToolbarItem {
//        Picker("Patterns", selection: $selectedPreset) {
//          ForEach(PatternStyle.allCases) { pattern in
//            Text(pattern.name).tag(pattern)
//          }
//        }
//      }
    }
    
  }
}
#if DEBUG
#Preview {
  GraphicContextPresetsView()
}
#endif

