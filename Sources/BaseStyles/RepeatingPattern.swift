//
//  RepeatingPattern.swift
//  Collection
//
//  Created by Dave Coleman on 29/9/2024.
//

import SwiftUI

public struct RepeatingPattern: ViewModifier {
  
  let displayMode: DisplayMode
  let lineWidth: CGFloat
  let gapSize: CGFloat
  let colour: Color
  let angle: Double
  
  public enum DisplayMode {
    case mask
    case maskInverted
    case overlay
    case background
    case off
  }
  
  public func body(content: Content) -> some View {
    content
      .mask {
        
        if displayMode != .off {
          if displayMode == .mask {
            Pattern()
          } else if displayMode == .maskInverted {
            Color.white
              .overlay {
                Pattern()
                  .blendMode(.destinationOut)
              }
              .compositingGroup()
          }
        }

      } // END mask
      .background {
        if displayMode == .background {
          Pattern()
        }
      }
      .overlay {
        if displayMode == .overlay {
          Pattern()
        }
      }
  }
}

extension RepeatingPattern {
  @ViewBuilder
  func Pattern() -> some View {
    
    if displayMode != .off {
      Canvas { context, size in
        
        //        let adjustedColour = displayMode == .mask ? Color.white : colour
        
        // Calculate the diagonal length of the view
        let diagonal = sqrt(size.width * size.width + size.height * size.height)
        
        // Calculate the number of lines needed to cover the diagonal
        let lineCount = Int(diagonal / (lineWidth + gapSize)) + 2 // Add extra lines
        
        // Create the path for a single line
        let path = Path { p in
          p.move(to: CGPoint(x: -diagonal, y: -diagonal))
          p.addLine(to: CGPoint(x: diagonal, y: diagonal))
        }
        
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.rotate(by: .degrees(angle * 4))
        
        for i in -lineCount...lineCount {
          let xOffset = CGFloat(i) * (lineWidth + gapSize)
          context.translateBy(x: xOffset, y: 0)
          context.stroke(path, with: .color(colour), lineWidth: lineWidth)
          context.translateBy(x: -xOffset, y: 0)
        }
        
      } // END canvas
      //      .drawingGroup()
    } // END isOn check
  }
}

public extension View {
  func repeatingPattern(
    displayMode: RepeatingPattern.DisplayMode = .background,
    lineWidth: CGFloat = 1,
    gapSize: CGFloat = 6,
    colour: Color = .white.opacity(0.1),
    angle: Double = -45
  ) -> some View {
    self.modifier(
      RepeatingPattern(
        displayMode: displayMode,
        lineWidth: lineWidth,
        gapSize: gapSize,
        colour: colour,
        angle: angle
      )
    )
  }
}


struct PatternExampleView: View {
  
  var body: some View {
    
    ZStack {
      Text("Some example text")
        .font(.largeTitle)
      //        .scaleEffect(6.5)
        .frame(width: 300, height: 200)
        .repeatingPattern(displayMode: .mask, lineWidth: 1, gapSize: 8, colour: .black)
      
      Color.blue
        .repeatingPattern(displayMode: .overlay, lineWidth: 1, gapSize: 8, colour: .blue)
        .opacity(0.2)
      
      
    }
    
    .padding(40)
    .frame(width: 300, height: 700)
    .background(.red.opacity(0.1))
    
  }
}
#Preview {
  PatternExampleView()
}
