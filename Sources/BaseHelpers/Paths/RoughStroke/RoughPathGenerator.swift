//
//  RandomValueCache.swift
//  Components
//
//  Created by Dave Coleman on 11/12/2024.
//

import SwiftUI
import BaseHelpers


public struct RoughPathGenerator {
  private let style: RoughPathStyle
  private var randomGenerator: RandomValueGenerator<RoughPathVariations>
  private var cachedVariations: RoughPathVariations?
  
  public init(style: RoughPathStyle) {
    self.style = style
    self.randomGenerator = RandomValueGenerator(seed: style.seed)
  }
  
  private mutating func getVariations(forPointCount count: Int) -> RoughPathVariations? {
    if cachedVariations?.pointCount != count || cachedVariations == nil {
      cachedVariations = randomGenerator.generate(
        count: count,
        parameters: .init(
          ranges: [-style.roughness...style.roughness],
          additionalParams: [
            "roughness": style.roughness,
            "jitter": style.jitter
          ]
        )
      )
    }
    return cachedVariations
  }
  
//  private mutating func jitterPoint(_ point: CGPoint, index: Int, normal: CGPoint? = nil) -> CGPoint {
//    guard let variations = getVariations(forPointCount: index + 1) else {
//      return point
//    }
//    
//    if let normal = normal {
//      /// Apply jitter mainly along the normal vector to prevent self-intersections
//      let jitterAmount = variations.xOffsets[index]
//      return CGPoint(
//        x: point.x + normal.x * jitterAmount,
//        y: point.y + normal.y * jitterAmount
//      )
//    } else {
//      // Fallback to current behavior for non-normal-based jitter
//      return CGPoint(
//        x: point.x + variations.xOffsets[index],
//        y: point.y + variations.yOffsets[index]
//      )
//    }
//  }
  private mutating func jitterPoint(_ point: CGPoint, index: Int) -> CGPoint {
    guard let variations = getVariations(forPointCount: index + 1) else {
      print("Error getting variations.")
      return point
    }
    guard index < variations.pointCount else { return point }
    return CGPoint(
      x: point.x + variations.xOffsets[index],
      y: point.y + variations.yOffsets[index]
    )
  }

  /// Roughens an existing Path
  public mutating func roughenPath(_ path: Path) -> Path {
    var roughPath = Path()
    var pointIndex = 0
    var isFirstPoint = true
    
    path.forEach { element in
      
      switch element {
        case .move(let to):
          
          if isFirstPoint {
            roughPath.move(to: jitterPoint(to, index: pointIndex))
            isFirstPoint = false
          } else {
            roughPath.addLine(to: jitterPoint(to, index: pointIndex))
          }
          pointIndex += 1
          
        case .line(let to):
          addRoughLine(
            to: &roughPath,
            end: to,
            startingIndex: pointIndex
          )
          pointIndex += style.segments
          
        case .curve(let to, let control1, let control2):
          addRoughCurve(
            to: &roughPath,
            end: to,
            control1: control1,
            control2: control2,
            startingIndex: pointIndex
          )
          pointIndex += style.segments * 2
          
        case .quadCurve(let to, let control):
          addRoughQuadCurve(
            to: &roughPath,
            end: to,
            control: control,
            startingIndex: pointIndex
          )
          pointIndex += style.segments
          
        case .closeSubpath:
          roughPath.closeSubpath()
      }
    } // END path element loop
    
    return roughPath
  }
  
  private mutating func addRoughLine(
    to path: inout Path,
    end: CGPoint,
    startingIndex: Int
  ) {
    let currentPoint = path.currentPoint ?? .zero
    
    for i in 0...style.segments {
      let t = CGFloat(i) / CGFloat(style.segments)
      let x = currentPoint.x + (end.x - currentPoint.x) * t
      let y = currentPoint.y + (end.y - currentPoint.y) * t
      
      let jitteredPoint = jitterPoint(
        CGPoint(x: x, y: y),
        index: startingIndex + i
      )
      
      path.addLine(to: jitteredPoint)
    }
  }
  
  
  private mutating func addRoughCurve(
    to path: inout Path,
    end: CGPoint,
    control1: CGPoint,
    control2: CGPoint,
    startingIndex: Int
  ) {
    let currentPoint = path.currentPoint ?? .zero
    
    for i in 0...style.segments {
      let t = CGFloat(i) / CGFloat(style.segments)
      
      // Cubic Bezier calculation
      let t2 = t * t
      let t3 = t2 * t
      let mt = 1 - t
      let mt2 = mt * mt
      let mt3 = mt2 * mt
      
      let x = currentPoint.x * mt3 +
      3 * control1.x * mt2 * t +
      3 * control2.x * mt * t2 +
      end.x * t3
      
      let y = currentPoint.y * mt3 +
      3 * control1.y * mt2 * t +
      3 * control2.y * mt * t2 +
      end.y * t3
      
      let jitteredPoint = jitterPoint(
        CGPoint(x: x, y: y),
        index: startingIndex + i
      )
      
      path.addLine(to: jitteredPoint)

    }
  }
  
  private mutating func addRoughQuadCurve(
    to path: inout Path,
    end: CGPoint,
    control: CGPoint,
    startingIndex: Int
  ) {
    let currentPoint = path.currentPoint ?? .zero
    
    for i in 0...style.segments {
      let t = CGFloat(i) / CGFloat(style.segments)
      
      // Quadratic Bezier calculation
      let t2 = t * t
      let mt = 1 - t
      let mt2 = mt * mt
      
      let x = currentPoint.x * mt2 +
      2 * control.x * mt * t +
      end.x * t2
      
      let y = currentPoint.y * mt2 +
      2 * control.y * mt * t +
      end.y * t2
      
      let jitteredPoint = jitterPoint(
        CGPoint(x: x, y: y),
        index: startingIndex + i
      )
      
      path.addLine(to: jitteredPoint)

    }
  }
}
