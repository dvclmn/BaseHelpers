//
//  GradientOverlay.swift
//  SwiftUI Grainient
//
//  Created by Dave Coleman on 17/3/2024.
//

import Foundation
import SwiftUI
import GameplayKit
import BaseStyles


/// Example usage:
///
/// ```
/// let rng = GradientRNG(seed: 12345, viewSize: viewSize)
///
/// // Query individual attributes
/// if case .gradientType(let type) = rng.gradientType {
///   print("This seed produces a \(type) gradient")
/// }
///
/// // Or combine multiple queries
/// if case .gradientType(let type) = rng.gradientType,
///    case .angle(let angle) = rng.angle {
///   print("This seed produces a \(type) gradient at \(angle) degrees")
/// }
///
/// // Generate complete settings
/// if let settings = rng.generateSettings(version: config.version) {
///   // Use settings
/// }
/// ```

//public enum GrainientAttribute {
//  case gradientType(GradientType)
//  case angle(Double)
//  case startRadius(Double)
//  case endRadius(Double)
//  case originX(Double)
//  case originY(Double)
//  case colorCount(Int)
//}
//
//public struct GranientRNG {
//  private let seed: Int
//  private let likelihoodOfRadial: Double
//  private let viewSize: CGSize
//  
//  public init(
//    seed: Int,
//    likelihoodOfRadial: Double = 0.5,
//    viewSize: CGSize
//  ) {
//    self.seed = seed
//    self.likelihoodOfRadial = likelihoodOfRadial
//    self.viewSize = viewSize
//  }
//  
//  private func getRandomDouble(for keyPath: KeyPath<GranientRNG, GrainientAttribute>) -> Double {
//    let attributeSeed = "\(seed)-\(String(describing: keyPath))".hash
//    print("Attribute seed: \(attributeSeed)")
//    let attributeRandomSource = GKMersenneTwisterRandomSource(seed: UInt64(attributeSeed))
//    return Double(attributeRandomSource.nextInt(upperBound: 1000)) / 1000.0
//  }
//  
//  // Computed properties for each attribute
//  public var gradientType: GrainientAttribute {
//    .gradientType(getRandomDouble(for: \.gradientType) < likelihoodOfRadial ? .radial : .linear)
//  }
//  
//  public var angle: GrainientAttribute {
//    .angle(getRandomDouble(for: \.angle) * 360.0)
//  }
//  
//  public var originX: GrainientAttribute {
//    .originX(getRandomDouble(for: \.originX))
//  }
//  
//  public var originY: GrainientAttribute {
//    .originY(getRandomDouble(for: \.originY))
//  }
//  
//  public var startRadius: GrainientAttribute {
//    let minDimension = min(viewSize.width, viewSize.height)
//    let sizeMultiplierRange = 1.5 - 0.2
//    let sizeMultiplier = getRandomDouble(for: \.startRadius) * sizeMultiplierRange + 0.2
//    return .startRadius(minDimension * sizeMultiplier)
//  }
//  
//  public var endRadius: GrainientAttribute {
//    if case .startRadius(let startRadius) = self.startRadius {
//      let endRadiusMultiplierRange = 1.5 - 0.5
//      let endRadiusMultiplier = getRandomDouble(for: \.endRadius) * endRadiusMultiplierRange + 0.5
//      return .endRadius(startRadius * endRadiusMultiplier)
//    }
//    return .endRadius(0) // Fallback, should never happen
//  }
//  
  
//  // Legacy mode for backward compatibility
//  private func legacyGenerate() -> GrainientSettings {
//    let randomSource = GKMersenneTwisterRandomSource(seed: UInt64(seed))
//    let randomDouble = { Double(randomSource.nextInt(upperBound: 1000)) / 1000.0 }
//    
//    // Your original logic here
//    let gradientType = randomDouble() < likelihoodOfRadial ? .radial : .linear
//    let angle = randomDouble() * 360.0
//    // etc...
//  }
  
  
  
//  
//  // Helper function to generate the complete settings
//  public func generateSettings(
//    version: GrainientVersion,
//    numberOfColours: Int = 3
//  ) -> GrainientSettings? {
//    // Extract values using pattern matching
//    guard
//      case .gradientType(let type) = gradientType,
//      case .angle(let angleValue) = angle,
//      case .startRadius(let start) = startRadius,
//      case .endRadius(let end) = endRadius,
//      case .originX(let x) = originX,
//      case .originY(let y) = originY
//    else { return nil }
//    
//    let swatches = generateSwatches(numberOfColours: numberOfColours, version: version)
//    let stops = swatches.enumerated().map { index, swatch in
//      Gradient.Stop(
//        color: swatch.colour,
//        location: CGFloat(index) / max(CGFloat(numberOfColours - 1), 1)
//      )
//    }.sorted(by: { $0.location < $1.location })
//    
//    return GrainientSettings(
//      gradientType: type,
//      angle: angleValue,
//      startRadius: start,
//      endRadius: end,
//      originX: x,
//      originY: y,
//      stops: stops,
//      colours: swatches
//    )
//  }
//  
//  private func generateSwatches(numberOfColours: Int, version: GrainientVersion) -> [Swatch] {
//    (0..<numberOfColours).compactMap { i in
//      let swatchSeed = "\(seed)-swatch-\(i)".hash
//      let swatchRandomSource = GKMersenneTwisterRandomSource(seed: UInt64(swatchSeed))
//      return Self.randomColourForGrainient(from: version.swatches, using: swatchRandomSource)
//    }
//  }
//  
//
//}


public enum GradientType: Codable {
  case linear, radial
}

public struct GrainientSettings {
  
  public var gradientType: GradientType
  
  /// The angle in degrees for Linear Gradients
  public var angle: Double
  
  /// Applies only to Radial Gradients
  public var startRadius: Double
  public var endRadius: Double
  
  public var originX: Double
  public var originY: Double
  public var stops: [Gradient.Stop]
  public var colours: [Swatch]
  
  
  // MARK: - Generate a Random Seed
  public static func generateGradientSeed() -> Int {
    let randomSeed = Int.random(in: 10000...99999)
    return randomSeed
  }
  
//  // MARK: - Generate a predictable Gradient from a Seed (deterministic)
  public static func generateGradient(
    seed: Int,
    version: GrainientVersion,
    likelihoodOfRadial: Double = 0.5,
    viewSize: CGSize,
    numberOfColours: Int = 3
  ) -> GrainientSettings {
    
    /// Create a seeded random source with the extracted randomSeed
    let randomSource = GKMersenneTwisterRandomSource(seed: UInt64(seed))
    let randomDouble = { Double(randomSource.nextInt(upperBound: 1000)) / 1000.0 }
    
    let gradientType: GradientType = randomDouble() < likelihoodOfRadial ? .radial : .linear
    let angle = randomDouble() * 360.0
    let originX = randomDouble()
    let originY = randomDouble()
    
    let minDimension = min(viewSize.width, viewSize.height)
    let sizeMultiplierRange = 1.5 - 0.2
    let sizeMultiplier = randomDouble() * sizeMultiplierRange + 0.2
    
    let startRadius = minDimension * sizeMultiplier
    let endRadiusMultiplierRange = 1.5 - 0.5
    let endRadiusMultiplier = randomDouble() * endRadiusMultiplierRange + 0.5
    
    let endRadius = max(startRadius * endRadiusMultiplier, startRadius * 1.1)
//    let endRadius = startRadius * endRadiusMultiplier
    
    var swatchList: [Swatch] = []
    for _ in 1...numberOfColours {
      if let swatch = Self.randomColourForGrainient(from: version.swatches, using: randomSource) {
        swatchList.append(swatch)
      } else {
        // Handle the case where no colour was returned, e.g., add a default color or skip
        print("No valid colour was picked; skipping this slot.")
        break
      }
    }
    
    let stops = swatchList.enumerated().compactMap { (index, swatch) -> Gradient.Stop? in
      
      let location = CGFloat(index) / CGFloat(numberOfColours - 1)
      return Gradient.Stop(color: swatch.colour, location: location)
      
    }.sorted(by: { $0.location < $1.location })
    
    return GrainientSettings(
      gradientType: gradientType,
      angle: angle,
      startRadius: startRadius,
      endRadius: endRadius,
      originX: originX,
      originY: originY,
      stops: stops,
      colours: swatchList
    )
  } // END generateGradient
  
  public static func randomColourForGrainient(
      from includedColours: [Swatch],
      using randomSource: GKRandomSource
    ) -> Swatch? {
  
      guard !includedColours.isEmpty else {
        print("No colours to pick from.")
        return nil
      }
  
      let randomIndex = randomSource.nextInt(upperBound: includedColours.count)
      return includedColours[randomIndex]
    }
  
} // END Gradient Settings


public enum GrainientVersion: Codable, Sendable {
  case v1
  case v2
  case v3
  
  public var swatches: [Swatch] {
    switch self {
      case .v1:
        return [
          .greenPewter,
          .greyLight,
          .grey,
          .blueChalk,
          .purpleLavendar,
          .purpleHazy,
          .olive,
          .slate
        ]
      case .v2:
        return [
          .greenPewter,
          .greyLight,
          .grey,
          .plum,
          .purpleEggplant,
          .peach,
          .blueChalk,
          .purpleLavendar,
          .purpleHazy,
          .olive,
          .slate
        ]
      case .v3:
        return [
          .greenPewter,
          .yellowMuted,
          .greyLight,
          .grey,
          .blueChalk,
          .plum,
          .blueNavy,
          .brownHazel,
          .brownEarth,
          .greenAqua,
          .purpleEggplant,
          .peach,
          .purpleLavendar,
          .purpleHazy,
          .olive,
          .slate
        ]
    }
  } // END swatchs
} // END grainient version


