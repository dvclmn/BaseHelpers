//
//  Grainient Modifier.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation
import SwiftUI
import BaseStyles

//
//public struct Grainient: ShapeStyle {
//  
//  public let seed: Int?
//  public let viewSize: CGSize?
//  
//  public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
//    if let seed = seed {
//      return grainyGradient(seed, viewSize: viewSize)
//    } else {
//      return AnyShapeStyle(Color.clear)
//    }
//  }
//  
//  func grainyGradient(_ seed: Int, viewSize: CGSize?) -> AnyShapeStyle {
//    
//    let grainientSettings = GrainientSettings.generateGradient(
//      seed: seed,
//      version: .v3,
//      viewSize: viewSize ?? .zero
//    )
//    
//    let gradient = Gradient(stops: grainientSettings.stops.map { Gradient.Stop(color: $0.color, location: $0.location) })
//    
//    let angle: Angle = Angle(degrees: grainientSettings.angle)
//    
//    
//    if grainientSettings.gradientType == .radial {
//      return AnyShapeStyle(RadialGradient(
//        gradient: gradient,
//        center: UnitPoint(x: grainientSettings.originX, y: grainientSettings.originY),
//        startRadius: grainientSettings.startSize,
//        endRadius: grainientSettings.endSize
//      ))
//      //          .frame(width: geometry.size.width, height: geometry.size.height)
//    } else {
//      return AnyShapeStyle(LinearGradient(
//        gradient: gradient,
//        startPoint: UnitPoint(x: 0, y: 0),
//        endPoint: UnitPoint(x: cos(angle.radians), y: sin(angle.radians))
//      ))
//      //          .frame(width: geometry.size.width, height: geometry.size.height)
//    }
//    
//    //      .task(id: seed) {
//    //        swatchOutput(grainientSettings.colours)
//    //      }
//    
//    //
//    
//    
//  } // END gradient view builder
//}
//
//public extension ShapeStyle where Self == Grainient {
//  static func grainient(with seed: Int?) -> Grainient {
//    Grainient(seed: seed, viewSize: nil)
//  }
//  //  static var text: ThemeColor { ThemeColor(\.text) }
//  //  static var highlight: ThemeColor { ThemeColor(\.highlight) }
//}



// MARK: - Grain overlay
public struct GrainientModifier: ViewModifier {
  
//  var style: Grainient?
  var seed: Int?
  
  var config: GrainientConfiguration
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
      .grainOverlay(opacity: seed == nil ? 0 : config.grainOpacity)
  }
}

extension GrainientModifier {
  @ViewBuilder
  func grainyGradient(_ seed: Int) -> some View {
    
    GeometryReader { geometry in
      let viewSize = geometry.size
      
      // TODO: A lot of this code seems to get called whenever the geometry view size changes. There may be a way to save some performance by only redrawing what needs to be?
      let grainientSettings = GrainientSettings.generateGradient(
        seed: seed,
        version: config.version,
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
  let rounding: CGFloat
  
  public init(
    version: GrainientVersion = .v3,
    grainOpacity: CGFloat = 0.3,
    blur: CGFloat = 50,
    opacity: CGFloat = 1.0,
    rounding: CGFloat = 0
  ) {
    self.version = version
    self.grainOpacity = grainOpacity
    self.blur = blur
    self.opacity = opacity
    self.rounding = rounding
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


