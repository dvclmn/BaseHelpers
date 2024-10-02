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


public enum GradientType: Codable {
  case linear, radial
}

public struct GradientStop {
  public var color: Color
  public var location: CGFloat
}

public struct GrainientSettings {
  
  public var gradientType: GradientType
  public var angle: Double
  public var startSize: Double
  public var endSize: Double
  public var originX: Double
  public var originY: Double
  public var stops: [GradientStop]
  public var colours: [Swatch]
  
  public static func generateGradientSeed() -> Int {
    let randomSeed = Int.random(in: 10000...99999)
//    print("1 seed: \(randomSeed)")
    return randomSeed
  }
  
  public static func generateGradient(
    seed: Int,
    version: GrainientVersion,
    likelihoodOfRadial: Double = 0.5,
    viewSize: CGSize,
    numberOfColours: Int = 3
  ) -> GrainientSettings {
    
    //        print("Let's generate a gradient, with seed \(seed).")
    
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
    
    let startSize = minDimension * sizeMultiplier
    let endSizeMultiplierRange = 1.5 - 0.5
    let endSizeMultiplier = randomDouble() * endSizeMultiplierRange + 0.5
    let endSize = startSize * endSizeMultiplier
    
    var swatchList: [Swatch] = []
    for _ in 1...numberOfColours {
      if let swatch = randomColourForGrainient(from: version.swatches, using: randomSource) {
        swatchList.append(swatch)
      } else {
        // Handle the case where no colour was returned, e.g., add a default color or skip
        print("No valid colour was picked; skipping this slot.")
      }
    }
    
    let stops = swatchList.enumerated().compactMap { (index, swatch) -> GradientStop? in
      
      let location = CGFloat(index) / CGFloat(numberOfColours - 1)
      return GradientStop(color: swatch.colour, location: location)
    }.sorted(by: { $0.location < $1.location })
    
    return GrainientSettings(
      gradientType: gradientType,
      angle: angle,
      startSize: startSize,
      endSize: endSize,
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
    //        print("\n\n|--- Get random Swatch colour --->\n")
    //        print("Let's return a Swatch, ensuring that it is from the included colours: \(includedColours)\n")
    
    guard !includedColours.isEmpty else {
      //            print("No colours to pick from.")
      return nil  // Return nil or handle appropriately
    }
    
    let randomIndex = randomSource.nextInt(upperBound: includedColours.count)
    //        print("Picked one! It is: \(includedColours[randomIndex])")
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
          .pewter,
          .lightGrey,
          .grey,
          .chalkBlue,
          .lavendar,
          .hazyPurple,
          .olive,
          .slate
        ]
      case .v2:
        return [
          .pewter,
          .lightGrey,
          .grey,
          .plum,
          .eggplant,
          .peach,
          .chalkBlue,
          .lavendar,
          .hazyPurple,
          .olive,
          .slate
        ]
      case .v3:
        return [
          .pewter,
          .sandy,
          .lightGrey,
          .grey,
          .chalkBlue,
          .plum,
          .navy,
          .hazel,
          .earth,
          .aqua,
          .eggplant,
          .peach,
          .lavendar,
          .hazyPurple,
          .olive,
          .slate
        ]
    }
  } // END swatchs
} // END grainient version


