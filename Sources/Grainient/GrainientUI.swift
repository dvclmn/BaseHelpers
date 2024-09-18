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
public struct Grainient: ViewModifier {
  
  var seed: Int?
  var version: GrainientVersion
  var grainOpacity: Double
  var blurAmount: Double
  var opacity: Double
  var uiDimming: Double
  var swatchOutput: (_ swatches: [Swatch]) -> Void
  
  public func body(content: Content) -> some View {
    
    /// Unwrapping seed here allows this modifier to be conditional. Providing the option for no grainient at all, if no seed provided. Caution: Do not place the `content` behind the unwrap, or no content will show in the View
    content
      .background {
        if let seed = seed {
          grainyGradient(seed)
            .allowsHitTesting(false)
            .overlay(.black.opacity(uiDimming))
            .ignoresSafeArea()
            .animation(.smooth(duration: 2.6, extraBounce: 0.2), value: seed)
        }
      }
      .grainOverlay(opacity: seed == nil ? 0 : grainOpacity)
      
  }
  
  @ViewBuilder
  func grainyGradient(_ seed: Int) -> some View {
    
    GeometryReader { geometry in
      let viewSize = geometry.size
      
      // TODO: A lot of this code seems to get called whenever the geometry view size changes. There may be a way to save some performance by only redrawing what needs to be?
      let grainientSettings = GrainientSettings.generateGradient(
        seed: seed,
        version: version,
        viewSize: viewSize
      )
      
      let gradient = Gradient(stops: grainientSettings.stops.map { Gradient.Stop(color: $0.color, location: $0.location) })
      
      let angle: Angle = Angle(degrees: grainientSettings.angle)
      
      Group {
        if grainientSettings.gradientType == .radial {
          RadialGradient(
            gradient: gradient,
            center: UnitPoint(x: grainientSettings.originX, y: grainientSettings.originY),
            startRadius: grainientSettings.startSize,
            endRadius: grainientSettings.endSize
          )
          .frame(width: geometry.size.width, height: geometry.size.height)
        } else {
          LinearGradient(
            gradient: gradient,
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: cos(angle.radians), y: sin(angle.radians))
          )
          .frame(width: geometry.size.width, height: geometry.size.height)
        }
      }
      .task(id: seed) {
        swatchOutput(grainientSettings.colours)
      }
    }
    .blur(radius: blurAmount, opaque: true)
    .clipped()
    .opacity(opacity)
    
    
  } // END gradient view builder
}
public extension View {
  func grainient(
    /// Having this as optional allows me to only show a grainient if there is a seed
    seed: Int?,
    version: GrainientVersion,
    grainOpacity: Double = 0.4,
    blurAmount: Double = 50,
    opacity: Double = 1.0,
    uiDimming: Double = 0.4,
    swatchOutput: @escaping (_ swatches: [Swatch]) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      Grainient(
        seed: seed,
        version: version,
        grainOpacity: grainOpacity,
        blurAmount: blurAmount,
        opacity: opacity,
        uiDimming: uiDimming,
        swatchOutput: swatchOutput
      )
    )
  }
}
