//
//  BFP+Zoom.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/8/2025.
//

import Foundation

extension BinaryFloatingPoint {
  public init(
    _ value: Self,
    removingZoom zoom: Self,
    with sensitivity: Self = 0.5
  ) {
    let clampedSensitivity = Double(sensitivity.clamped(to: 0...1))
    let adjusted = value * Self(pow(Double(zoom), clampedSensitivity - 1))
    self.init(adjusted)
  }
  
  public func removingZoom(
    _ zoom: Self,
    clampedTo range: ClosedRange<Self>? = nil
  ) -> Self {
    guard let range else {
      return self / zoom
    }
    let clampedZoom = zoom.clamped(to: range)
    return self / clampedZoom
  }
  
  /// This removes a zoom range which has been normalised from 0-1
  func removingZoomPercent(_ zoomPercent: Self) -> Self {
    let result = Double(self) / pow(1 + Double(zoomPercent), 1)
    return Self(result)
  }
  
  /// Applies non-linear zoom scaling to provide better control at different zoom levels
  /// - Parameters:
  ///   - zoomLevel: The current zoom level (0.1...60)
  ///   - zoomRange: The valid zoom range
  ///   - lowSensitivityThreshold: Zoom level below which sensitivity is reduced (default: 1.0)
  ///   - highSensitivityThreshold: Zoom level above which sensitivity is increased (default: 5.0)
  ///   - curve: The power curve factor (default: 1.5). Higher values = more dramatic curve
  /// - Returns: The transformed zoom scale to apply to the view
  public static func nonLinearZoomScale(
    zoomLevel: Double,
    zoomRange: ClosedRange<Double>,
    lowSensitivityThreshold: Double = 1.0,
    highSensitivityThreshold: Double = 5.0,
    curve: Double = 1.5
  ) -> Double {
    
    // Clamp the zoom level to the valid range
    let clampedZoom = min(max(zoomLevel, zoomRange.lowerBound), zoomRange.upperBound)
    
    // Normalize the zoom level to 0...1 range
    let normalizedZoom = (clampedZoom - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)
    
    // Calculate threshold positions in normalized space
    let lowThresholdNorm =
    (lowSensitivityThreshold - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)
    let highThresholdNorm =
    (highSensitivityThreshold - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)
    
    let transformedZoom: Double
    
    if normalizedZoom <= lowThresholdNorm {
      // Low zoom range: reduce sensitivity (expand the curve - slower response)
      let localNorm = normalizedZoom / lowThresholdNorm
      let expanded = pow(localNorm, curve)  // Use curve to slow down response
      transformedZoom = expanded * lowThresholdNorm
      
    } else if normalizedZoom >= highThresholdNorm {
      // High zoom range: increase sensitivity (compress the curve - faster response)
      let localNorm = (normalizedZoom - highThresholdNorm) / (1.0 - highThresholdNorm)
      let compressed = pow(localNorm, 1.0 / curve)  // Inverse curve for faster response
      transformedZoom = highThresholdNorm + compressed * (1.0 - highThresholdNorm)
      
    } else {
      // Middle range: linear scaling
      transformedZoom = normalizedZoom
    }
    
    // Convert back to actual zoom range
    return transformedZoom * (zoomRange.upperBound - zoomRange.lowerBound) + zoomRange.lowerBound
  }
  
  /// Simplified non-linear zoom scaling using a single curve parameter
  /// - Parameters:
  ///   - zoomLevel: The current zoom level
  ///   - zoomRange: The valid zoom range
  ///   - sensitivity: Controls the curve (values < 1.0 = less sensitive at low zoom, values > 1.0 = more sensitive at low zoom)
  /// - Returns: The transformed zoom scale
  public static func simpleNonLinearZoomScale(
    zoomLevel: Double,
    zoomRange: ClosedRange<Double>,
    sensitivity: Double = 1.3
  ) -> Double {
    let clampedZoom = min(max(zoomLevel, zoomRange.lowerBound), zoomRange.upperBound)
    let normalizedZoom = (clampedZoom - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)
    let transformedZoom = pow(normalizedZoom, sensitivity)
    return transformedZoom * (zoomRange.upperBound - zoomRange.lowerBound) + zoomRange.lowerBound
  }

}
