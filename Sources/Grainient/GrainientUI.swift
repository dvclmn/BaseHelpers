//
//  Grainient Modifier.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation
import SwiftUI
import BaseStyles



// MARK: - Grain overlay
public struct GrainientModifier: ViewModifier {
  
  var seed: Int?
  
  var config: GrainientConfiguration
  var uiDimming: Double
  var swatchOutput: (_ swatches: [Swatch]) -> Void
  
  public func body(content: Content) -> some View {

    content
      .background {
        if let seed = seed {
          GrainientView(seed)
            .allowsHitTesting(false)
            .overlay(.black.opacity(uiDimming))
            .ignoresSafeArea()
            .animation(.smooth(duration: 2.6, extraBounce: 0.2), value: seed)
        }
      }
      .grainOverlay(opacity: seed == nil ? 0 : config.grainOpacity)
  }
}

extension GrainientModifier {
  @ViewBuilder
  func GrainientView(_ seed: Int) -> some View {
    
    GeometryReader { geometry in

      let grainientSettings = GrainientSettings.generateGradient(
        seed: seed,
        version: .v3,
        viewSize: geometry.size
      )
        
        let gradient = Gradient(stops: grainientSettings.stops)
        
        let angle = Angle(degrees: grainientSettings.angle)
        
        Group {
          switch grainientSettings.gradientType {
            case .linear:
              LinearGradient(
                gradient: gradient,
                startPoint: UnitPoint(x: 0, y: 0),
                endPoint: UnitPoint(x: cos(angle.radians), y: sin(angle.radians))
              )
              
            case .radial:
              RadialGradient(
                gradient: gradient,
                center: UnitPoint(x: grainientSettings.originX, y: grainientSettings.originY),
                startRadius: grainientSettings.startRadius,
                endRadius: grainientSettings.endRadius
              )
          } // END switch
        } // END group
        .frame(width: geometry.size.width, height: geometry.size.height)
        .task(id: seed) {
          swatchOutput(grainientSettings.colours)
        }
      
    } // END geo reader
    .blur(radius: config.blur, opaque: true)
    .clipped()
    .opacity(config.opacity)
    
  } // END gradient view builder
}

public struct GrainientConfiguration {
  let version: GrainientVersion
  let grainOpacity: CGFloat
  let blur: CGFloat
  let opacity: CGFloat
  
  public init(
    version: GrainientVersion = .v3,
    grainOpacity: CGFloat = 0.3,
    blur: CGFloat = 50,
    opacity: CGFloat = 1.0
  ) {
    self.version = version
    self.grainOpacity = grainOpacity
    self.blur = blur
    self.opacity = opacity
  }
}

public extension View {
  func grainient(
    seed: Int?,
    config: GrainientConfiguration = .init(),
    uiDimming: Double = 0.4,
    swatchOutput: @escaping (_ swatches: [Swatch]) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      GrainientModifier(
        seed: seed,
        config: config,
        uiDimming: uiDimming,
        swatchOutput: swatchOutput
      )
    )
  } // END seed-based grainient
  
}


