//
//  TouchPointExamples.swift
//  LilyPad
//
//  Created by Dave Coleman on 31/5/2025.
//

import Foundation

extension TouchPoint {
  
  private static let mockDeviceSize: CGSize = .init(width: 700, height: 438)

  public static let exampleGroup: [TouchPoint] = [
    example01,
    example02,
    topLeading,
    topTrailing,
    bottomLeading,
    bottomTrailing,
  ]

  public static let example01 = TouchPoint(
    id: 1,
    phase: .ended,
    position: CGPoint(
      x: 0.2,
      y: 0.6
    ),
    timestamp: 1,
    velocity: CGVector(
      dx: 2,
      dy: 9
    ),
    pressure: 0.5,
    deviceSize: mockDeviceSize,
    isResting: false
  )
  
  public static let example02 = TouchPoint(
    id: 2,
    phase: .ended,
    position: CGPoint(
      x: 0.4,
      y: 0.4
    ),
    timestamp: 2,
    velocity: CGVector(
      dx: 2,
      dy: 9
    ),
    pressure: 0.2,
    deviceSize: mockDeviceSize,
    isResting: false
  )
  
  public static let topLeading = TouchPoint(
    id: 3,
    phase: .ended,
    position: CGPoint(
      x: 0,
      y: 0
    ),
    timestamp: 6,
    velocity: CGVector(
      dx: 2,
      dy: 9
    ),
    pressure: 0.5,
    deviceSize: mockDeviceSize,
    isResting: false
  )
  
  public static let topTrailing = TouchPoint(
    id: 4,
    phase: .ended,
    position: CGPoint(
      x: 1.0,
      y: 0
    ),
    timestamp: 10,
    velocity: CGVector(
      dx: 2,
      dy: 9
    ),
    pressure: 0.5,
    deviceSize: mockDeviceSize,
    isResting: false
  )
  public static let bottomLeading = TouchPoint(
    id: 5,
    phase: .ended,
    position: CGPoint(
      x: 0,
      y: 1.0
    ),
    timestamp: 16,
    velocity: CGVector(
      dx: 2,
      dy: 9
    ),
    pressure: 0.5,
    deviceSize: mockDeviceSize,
    isResting: false
  )
  public static let bottomTrailing = TouchPoint(
    id: 6,
    phase: .ended,
    position: CGPoint(
      x: 1.0,
      y: 1.0
    ),
    timestamp: 19,
    velocity: CGVector(
      dx: 2,
      dy: 9
    ),
    pressure: 0.5,
    deviceSize: mockDeviceSize,
    isResting: false
  )
  
//  // MARK: - Spiral Pattern (60 points)
//  public static let spiralPoints: [TouchPoint] = [
//    TouchPoint(
//      id: 1,
//      phase: .began,
//      position: CGPoint(
//        x: 0.5,
//        y: 0.5
//      ),
//      timestamp: 0.0,
//      velocity: CGVector(
//        dx: 0,
//        dy: 0
//      ),
//      pressure: 0.3
//    ),
//    TouchPoint(
//      id: 2,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.52,
//        y: 0.5
//      ),
//      timestamp: 0.016,
//      velocity: CGVector(
//        dx: 1.2,
//        dy: 0
//      ),
//      pressure: 0.4
//    ),
//    TouchPoint(
//      id: 3,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.525,
//        y: 0.475
//      ),
//      timestamp: 0.033,
//      velocity: CGVector(
//        dx: 0.8,
//        dy: -1.5
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 4,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.515,
//        y: 0.455
//      ),
//      timestamp: 0.05,
//      velocity: CGVector(
//        dx: -0.6,
//        dy: -1.2
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 5,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.495,
//        y: 0.445
//      ),
//      timestamp: 0.066,
//      velocity: CGVector(
//        dx: -1.2,
//        dy: -0.6
//      ),
//      pressure: 0.52
//    ),
//    TouchPoint(
//      id: 6,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.47,
//        y: 0.45
//      ),
//      timestamp: 0.083,
//      velocity: CGVector(
//        dx: -1.5,
//        dy: 0.3
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 7,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.445,
//        y: 0.465
//      ),
//      timestamp: 0.1,
//      velocity: CGVector(
//        dx: -1.5,
//        dy: 0.9
//      ),
//      pressure: 0.57
//    ),
//    TouchPoint(
//      id: 8,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.425,
//        y: 0.49
//      ),
//      timestamp: 0.116,
//      velocity: CGVector(
//        dx: -1.2,
//        dy: 1.5
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 9,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.415,
//        y: 0.52
//      ),
//      timestamp: 0.133,
//      velocity: CGVector(
//        dx: -0.6,
//        dy: 1.8
//      ),
//      pressure: 0.62
//    ),
//    TouchPoint(
//      id: 10,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.42,
//        y: 0.55
//      ),
//      timestamp: 0.15,
//      velocity: CGVector(
//        dx: 0.3,
//        dy: 1.8
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 11,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.435,
//        y: 0.575
//      ),
//      timestamp: 0.166,
//      velocity: CGVector(
//        dx: 0.9,
//        dy: 1.5
//      ),
//      pressure: 0.67
//    ),
//    TouchPoint(
//      id: 12,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.46,
//        y: 0.59
//      ),
//      timestamp: 0.183,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 0.9
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 13,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.49,
//        y: 0.595
//      ),
//      timestamp: 0.2,
//      velocity: CGVector(
//        dx: 1.8,
//        dy: 0.3
//      ),
//      pressure: 0.72
//    ),
//    TouchPoint(
//      id: 14,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.52,
//        y: 0.59
//      ),
//      timestamp: 0.216,
//      velocity: CGVector(
//        dx: 1.8,
//        dy: -0.3
//      ),
//      pressure: 0.75
//    ),
//    TouchPoint(
//      id: 15,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.545,
//        y: 0.575
//      ),
//      timestamp: 0.233,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -0.9
//      ),
//      pressure: 0.77
//    ),
//    TouchPoint(
//      id: 16,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.55
//      ),
//      timestamp: 0.25,
//      velocity: CGVector(
//        dx: 1.2,
//        dy: -1.5
//      ),
//      pressure: 0.8
//    ),
//    TouchPoint(
//      id: 17,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.575,
//        y: 0.52
//      ),
//      timestamp: 0.266,
//      velocity: CGVector(
//        dx: 0.6,
//        dy: -1.8
//      ),
//      pressure: 0.78
//    ),
//    TouchPoint(
//      id: 18,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.575,
//        y: 0.485
//      ),
//      timestamp: 0.283,
//      velocity: CGVector(
//        dx: 0,
//        dy: -2.1
//      ),
//      pressure: 0.75
//    ),
//    TouchPoint(
//      id: 19,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.45
//      ),
//      timestamp: 0.3,
//      velocity: CGVector(
//        dx: -0.6,
//        dy: -2.1
//      ),
//      pressure: 0.72
//    ),
//    TouchPoint(
//      id: 20,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.545,
//        y: 0.42
//      ),
//      timestamp: 0.316,
//      velocity: CGVector(
//        dx: -1.2,
//        dy: -1.8
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 21,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.515,
//        y: 0.395
//      ),
//      timestamp: 0.333,
//      velocity: CGVector(
//        dx: -1.8,
//        dy: -1.5
//      ),
//      pressure: 0.67
//    ),
//    TouchPoint(
//      id: 22,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.48,
//        y: 0.38
//      ),
//      timestamp: 0.35,
//      velocity: CGVector(
//        dx: -2.1,
//        dy: -0.9
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 23,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.44,
//        y: 0.375
//      ),
//      timestamp: 0.366,
//      velocity: CGVector(
//        dx: -2.4,
//        dy: -0.3
//      ),
//      pressure: 0.62
//    ),
//    TouchPoint(
//      id: 24,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.4,
//        y: 0.38
//      ),
//      timestamp: 0.383,
//      velocity: CGVector(
//        dx: -2.4,
//        dy: 0.3
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 25,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.365,
//        y: 0.395
//      ),
//      timestamp: 0.4,
//      velocity: CGVector(
//        dx: -2.1,
//        dy: 0.9
//      ),
//      pressure: 0.57
//    ),
//    TouchPoint(
//      id: 26,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.335,
//        y: 0.42
//      ),
//      timestamp: 0.416,
//      velocity: CGVector(
//        dx: -1.8,
//        dy: 1.5
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 27,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.315,
//        y: 0.45
//      ),
//      timestamp: 0.433,
//      velocity: CGVector(
//        dx: -1.2,
//        dy: 1.8
//      ),
//      pressure: 0.52
//    ),
//    TouchPoint(
//      id: 28,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.305,
//        y: 0.485
//      ),
//      timestamp: 0.45,
//      velocity: CGVector(
//        dx: -0.6,
//        dy: 2.1
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 29,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.305,
//        y: 0.52
//      ),
//      timestamp: 0.466,
//      velocity: CGVector(
//        dx: 0,
//        dy: 2.1
//      ),
//      pressure: 0.47
//    ),
//    TouchPoint(
//      id: 30,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.315,
//        y: 0.555
//      ),
//      timestamp: 0.483,
//      velocity: CGVector(
//        dx: 0.6,
//        dy: 2.1
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 31,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.335,
//        y: 0.585
//      ),
//      timestamp: 0.5,
//      velocity: CGVector(
//        dx: 1.2,
//        dy: 1.8
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 32,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.365,
//        y: 0.61
//      ),
//      timestamp: 0.516,
//      velocity: CGVector(
//        dx: 1.8,
//        dy: 1.5
//      ),
//      pressure: 0.52
//    ),
//    TouchPoint(
//      id: 33,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.4,
//        y: 0.625
//      ),
//      timestamp: 0.533,
//      velocity: CGVector(
//        dx: 2.1,
//        dy: 0.9
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 34,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.44,
//        y: 0.63
//      ),
//      timestamp: 0.55,
//      velocity: CGVector(
//        dx: 2.4,
//        dy: 0.3
//      ),
//      pressure: 0.57
//    ),
//    TouchPoint(
//      id: 35,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.48,
//        y: 0.625
//      ),
//      timestamp: 0.566,
//      velocity: CGVector(
//        dx: 2.4,
//        dy: -0.3
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 36,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.515,
//        y: 0.61
//      ),
//      timestamp: 0.583,
//      velocity: CGVector(
//        dx: 2.1,
//        dy: -0.9
//      ),
//      pressure: 0.62
//    ),
//    TouchPoint(
//      id: 37,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.545,
//        y: 0.585
//      ),
//      timestamp: 0.6,
//      velocity: CGVector(
//        dx: 1.8,
//        dy: -1.5
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 38,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.555
//      ),
//      timestamp: 0.616,
//      velocity: CGVector(
//        dx: 1.2,
//        dy: -1.8
//      ),
//      pressure: 0.67
//    ),
//    TouchPoint(
//      id: 39,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.575,
//        y: 0.52
//      ),
//      timestamp: 0.633,
//      velocity: CGVector(
//        dx: 0.6,
//        dy: -2.1
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 40,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.575,
//        y: 0.485
//      ),
//      timestamp: 0.65,
//      velocity: CGVector(
//        dx: 0,
//        dy: -2.1
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 41,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.45
//      ),
//      timestamp: 0.666,
//      velocity: CGVector(
//        dx: -0.6,
//        dy: -2.1
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 42,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.545,
//        y: 0.42
//      ),
//      timestamp: 0.683,
//      velocity: CGVector(
//        dx: -1.2,
//        dy: -1.8
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 43,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.515,
//        y: 0.395
//      ),
//      timestamp: 0.7,
//      velocity: CGVector(
//        dx: -1.8,
//        dy: -1.5
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 44,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.48,
//        y: 0.38
//      ),
//      timestamp: 0.716,
//      velocity: CGVector(
//        dx: -2.1,
//        dy: -0.9
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 45,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.44,
//        y: 0.375
//      ),
//      timestamp: 0.733,
//      velocity: CGVector(
//        dx: -2.4,
//        dy: -0.3
//      ),
//      pressure: 0.4
//    ),
//    TouchPoint(
//      id: 46,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.4,
//        y: 0.38
//      ),
//      timestamp: 0.75,
//      velocity: CGVector(
//        dx: -2.4,
//        dy: 0.3
//      ),
//      pressure: 0.35
//    ),
//    TouchPoint(
//      id: 47,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.365,
//        y: 0.395
//      ),
//      timestamp: 0.766,
//      velocity: CGVector(
//        dx: -2.1,
//        dy: 0.9
//      ),
//      pressure: 0.3
//    ),
//    TouchPoint(
//      id: 48,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.335,
//        y: 0.42
//      ),
//      timestamp: 0.783,
//      velocity: CGVector(
//        dx: -1.8,
//        dy: 1.5
//      ),
//      pressure: 0.25
//    ),
//    TouchPoint(
//      id: 49,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.315,
//        y: 0.45
//      ),
//      timestamp: 0.8,
//      velocity: CGVector(
//        dx: -1.2,
//        dy: 1.8
//      ),
//      pressure: 0.2
//    ),
//    TouchPoint(
//      id: 50,
//      phase: .ended,
//      position: CGPoint(
//        x: 0.305,
//        y: 0.485
//      ),
//      timestamp: 0.816,
//      velocity: CGVector(
//        dx: -0.6,
//        dy: 2.1
//      ),
//      pressure: 0.15
//    ),
//  ]
//  
//  // MARK: - Wave Pattern (45 points)
//  public static let wavePoints: [TouchPoint] = [
//    TouchPoint(
//      id: 51,
//      phase: .began,
//      position: CGPoint(
//        x: 0.1,
//        y: 0.5
//      ),
//      timestamp: 1.0,
//      velocity: CGVector(
//        dx: 0,
//        dy: 0
//      ),
//      pressure: 0.4
//    ),
//    TouchPoint(
//      id: 52,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.125,
//        y: 0.525
//      ),
//      timestamp: 1.02,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 1.5
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 53,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.15,
//        y: 0.55
//      ),
//      timestamp: 1.04,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 1.5
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 54,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.175,
//        y: 0.575
//      ),
//      timestamp: 1.06,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 1.5
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 55,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.2,
//        y: 0.6
//      ),
//      timestamp: 1.08,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 1.5
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 56,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.225,
//        y: 0.62
//      ),
//      timestamp: 1.1,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 1.2
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 57,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.25,
//        y: 0.63
//      ),
//      timestamp: 1.12,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 0.6
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 58,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.275,
//        y: 0.625
//      ),
//      timestamp: 1.14,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -0.3
//      ),
//      pressure: 0.72
//    ),
//    TouchPoint(
//      id: 59,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.3,
//        y: 0.61
//      ),
//      timestamp: 1.16,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -0.9
//      ),
//      pressure: 0.75
//    ),
//    TouchPoint(
//      id: 60,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.325,
//        y: 0.585
//      ),
//      timestamp: 1.18,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -1.5
//      ),
//      pressure: 0.77
//    ),
//    TouchPoint(
//      id: 61,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.35,
//        y: 0.55
//      ),
//      timestamp: 1.2,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -2.1
//      ),
//      pressure: 0.8
//    ),
//    TouchPoint(
//      id: 62,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.375,
//        y: 0.51
//      ),
//      timestamp: 1.22,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -2.4
//      ),
//      pressure: 0.82
//    ),
//    TouchPoint(
//      id: 63,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.4,
//        y: 0.47
//      ),
//      timestamp: 1.24,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -2.4
//      ),
//      pressure: 0.85
//    ),
//    TouchPoint(
//      id: 64,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.425,
//        y: 0.43
//      ),
//      timestamp: 1.26,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -2.4
//      ),
//      pressure: 0.87
//    ),
//    TouchPoint(
//      id: 65,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.45,
//        y: 0.395
//      ),
//      timestamp: 1.28,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -2.1
//      ),
//      pressure: 0.9
//    ),
//    TouchPoint(
//      id: 66,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.475,
//        y: 0.37
//      ),
//      timestamp: 1.3,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -1.5
//      ),
//      pressure: 0.87
//    ),
//    TouchPoint(
//      id: 67,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.5,
//        y: 0.355
//      ),
//      timestamp: 1.32,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -0.9
//      ),
//      pressure: 0.85
//    ),
//    TouchPoint(
//      id: 68,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.525,
//        y: 0.35
//      ),
//      timestamp: 1.34,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -0.3
//      ),
//      pressure: 0.82
//    ),
//    TouchPoint(
//      id: 69,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.55,
//        y: 0.355
//      ),
//      timestamp: 1.36,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 0.3
//      ),
//      pressure: 0.8
//    ),
//    TouchPoint(
//      id: 70,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.575,
//        y: 0.37
//      ),
//      timestamp: 1.38,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 0.9
//      ),
//      pressure: 0.77
//    ),
//    TouchPoint(
//      id: 71,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.6,
//        y: 0.395
//      ),
//      timestamp: 1.4,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 1.5
//      ),
//      pressure: 0.75
//    ),
//    TouchPoint(
//      id: 72,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.625,
//        y: 0.43
//      ),
//      timestamp: 1.42,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 2.1
//      ),
//      pressure: 0.72
//    ),
//    TouchPoint(
//      id: 73,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.65,
//        y: 0.47
//      ),
//      timestamp: 1.44,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 2.4
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 74,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.675,
//        y: 0.51
//      ),
//      timestamp: 1.46,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 2.4
//      ),
//      pressure: 0.67
//    ),
//    TouchPoint(
//      id: 75,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.7,
//        y: 0.55
//      ),
//      timestamp: 1.48,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 2.4
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 76,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.725,
//        y: 0.585
//      ),
//      timestamp: 1.5,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 2.1
//      ),
//      pressure: 0.62
//    ),
//    TouchPoint(
//      id: 77,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.75,
//        y: 0.61
//      ),
//      timestamp: 1.52,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 1.5
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 78,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.775,
//        y: 0.625
//      ),
//      timestamp: 1.54,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 0.9
//      ),
//      pressure: 0.57
//    ),
//    TouchPoint(
//      id: 79,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.8,
//        y: 0.63
//      ),
//      timestamp: 1.56,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: 0.3
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 80,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.825,
//        y: 0.625
//      ),
//      timestamp: 1.58,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -0.3
//      ),
//      pressure: 0.52
//    ),
//    TouchPoint(
//      id: 81,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.85,
//        y: 0.61
//      ),
//      timestamp: 1.6,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -0.9
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 82,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.875,
//        y: 0.585
//      ),
//      timestamp: 1.62,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -1.5
//      ),
//      pressure: 0.47
//    ),
//    TouchPoint(
//      id: 83,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.9,
//        y: 0.55
//      ),
//      timestamp: 1.64,
//      velocity: CGVector(
//        dx: 1.5,
//        dy: -2.1
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 84,
//      phase: .ended,
//      position: CGPoint(
//        x: 0.9,
//        y: 0.5
//      ),
//      timestamp: 1.66,
//      velocity: CGVector(
//        dx: 0,
//        dy: -3.0
//      ),
//      pressure: 0.3
//    ),
//  ]
//  
//  // MARK: - Figure-8 Pattern (50 points)
//  public static let figure8Points: [TouchPoint] = [
//    TouchPoint(
//      id: 85,
//      phase: .began,
//      position: CGPoint(
//        x: 0.5,
//        y: 0.3
//      ),
//      timestamp: 2.0,
//      velocity: CGVector(
//        dx: 0,
//        dy: 0
//      ),
//      pressure: 0.35
//    ),
//    TouchPoint(
//      id: 86,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.52,
//        y: 0.32
//      ),
//      timestamp: 2.02,
//      velocity: CGVector(
//        dx: 1.0,
//        dy: 1.0
//      ),
//      pressure: 0.4
//    ),
//    TouchPoint(
//      id: 87,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.54,
//        y: 0.35
//      ),
//      timestamp: 2.04,
//      velocity: CGVector(
//        dx: 1.0,
//        dy: 1.5
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 88,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.555,
//        y: 0.38
//      ),
//      timestamp: 2.06,
//      velocity: CGVector(
//        dx: 0.75,
//        dy: 1.5
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 89,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.41
//      ),
//      timestamp: 2.08,
//      velocity: CGVector(
//        dx: 0.5,
//        dy: 1.5
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 90,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.57,
//        y: 0.44
//      ),
//      timestamp: 2.1,
//      velocity: CGVector(
//        dx: 0.25,
//        dy: 1.5
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 91,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.57,
//        y: 0.47
//      ),
//      timestamp: 2.12,
//      velocity: CGVector(
//        dx: 0,
//        dy: 1.5
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 92,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.5
//      ),
//      timestamp: 2.14,
//      velocity: CGVector(
//        dx: -0.25,
//        dy: 1.5
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 93,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.555,
//        y: 0.53
//      ),
//      timestamp: 2.16,
//      velocity: CGVector(
//        dx: -0.5,
//        dy: 1.5
//      ),
//      pressure: 0.72
//    ),
//    TouchPoint(
//      id: 94,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.54,
//        y: 0.56
//      ),
//      timestamp: 2.18,
//      velocity: CGVector(
//        dx: -0.75,
//        dy: 1.5
//      ),
//      pressure: 0.75
//    ),
//    TouchPoint(
//      id: 95,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.52,
//        y: 0.58
//      ),
//      timestamp: 2.2,
//      velocity: CGVector(
//        dx: -1.0,
//        dy: 1.0
//      ),
//      pressure: 0.77
//    ),
//    TouchPoint(
//      id: 96,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.5,
//        y: 0.6
//      ),
//      timestamp: 2.22,
//      velocity: CGVector(
//        dx: -1.0,
//        dy: 1.0
//      ),
//      pressure: 0.8
//    ),
//    TouchPoint(
//      id: 97,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.48,
//        y: 0.58
//      ),
//      timestamp: 2.24,
//      velocity: CGVector(
//        dx: -1.0,
//        dy: -1.0
//      ),
//      pressure: 0.77
//    ),
//    TouchPoint(
//      id: 98,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.46,
//        y: 0.56
//      ),
//      timestamp: 2.26,
//      velocity: CGVector(
//        dx: -1.0,
//        dy: -1.0
//      ),
//      pressure: 0.75
//    ),
//    TouchPoint(
//      id: 99,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.445,
//        y: 0.53
//      ),
//      timestamp: 2.28,
//      velocity: CGVector(
//        dx: -0.75,
//        dy: -1.5
//      ),
//      pressure: 0.72
//    ),
//    TouchPoint(
//      id: 100,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.435,
//        y: 0.5
//      ),
//      timestamp: 2.3,
//      velocity: CGVector(
//        dx: -0.5,
//        dy: -1.5
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 101,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.43,
//        y: 0.47
//      ),
//      timestamp: 2.32,
//      velocity: CGVector(
//        dx: -0.25,
//        dy: -1.5
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 102,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.43,
//        y: 0.44
//      ),
//      timestamp: 2.34,
//      velocity: CGVector(
//        dx: 0,
//        dy: -1.5
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 103,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.435,
//        y: 0.41
//      ),
//      timestamp: 2.36,
//      velocity: CGVector(
//        dx: 0.25,
//        dy: -1.5
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 104,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.445,
//        y: 0.38
//      ),
//      timestamp: 2.38,
//      velocity: CGVector(
//        dx: 0.5,
//        dy: -1.5
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 105,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.46,
//        y: 0.35
//      ),
//      timestamp: 2.4,
//      velocity: CGVector(
//        dx: 0.75,
//        dy: -1.5
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 106,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.48,
//        y: 0.32
//      ),
//      timestamp: 2.42,
//      velocity: CGVector(
//        dx: 1.0,
//        dy: -1.5
//      ),
//      pressure: 0.4
//    ),
//    TouchPoint(
//      id: 107,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.5,
//        y: 0.3
//      ),
//      timestamp: 2.44,
//      velocity: CGVector(
//        dx: 1.0,
//        dy: -1.0
//      ),
//      pressure: 0.35
//    ),
//    TouchPoint(
//      id: 108,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.52,
//        y: 0.32
//      ),
//      timestamp: 2.46,
//      velocity: CGVector(
//        dx: 1.0,
//        dy: 1.0
//      ),
//      pressure: 0.4
//    ),
//    TouchPoint(
//      id: 109,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.54,
//        y: 0.35
//      ),
//      timestamp: 2.48,
//      velocity: CGVector(
//        dx: 1.0,
//        dy: 1.5
//      ),
//      pressure: 0.45
//    ),
//    TouchPoint(
//      id: 110,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.555,
//        y: 0.38
//      ),
//      timestamp: 2.5,
//      velocity: CGVector(
//        dx: 0.75,
//        dy: 1.5
//      ),
//      pressure: 0.5
//    ),
//    TouchPoint(
//      id: 111,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.41
//      ),
//      timestamp: 2.52,
//      velocity: CGVector(
//        dx: 0.5,
//        dy: 1.5
//      ),
//      pressure: 0.55
//    ),
//    TouchPoint(
//      id: 112,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.57,
//        y: 0.44
//      ),
//      timestamp: 2.54,
//      velocity: CGVector(
//        dx: 0.25,
//        dy: 1.5
//      ),
//      pressure: 0.6
//    ),
//    TouchPoint(
//      id: 113,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.57,
//        y: 0.47
//      ),
//      timestamp: 2.56,
//      velocity: CGVector(
//        dx: 0,
//        dy: 1.5
//      ),
//      pressure: 0.65
//    ),
//    TouchPoint(
//      id: 114,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.565,
//        y: 0.5
//      ),
//      timestamp: 2.58,
//      velocity: CGVector(
//        dx: -0.25,
//        dy: 1.5
//      ),
//      pressure: 0.7
//    ),
//    TouchPoint(
//      id: 115,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.555,
//        y: 0.53
//      ),
//      timestamp: 2.6,
//      velocity: CGVector(
//        dx: -0.5,
//        dy: 1.5
//      ),
//      pressure: 0.72
//    ),
//    TouchPoint(
//      id: 116,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.54,
//        y: 0.56
//      ),
//      timestamp: 2.62,
//      velocity: CGVector(
//        dx: -0.75,
//        dy: 1.5
//      ),
//      pressure: 0.75
//    ),
//    TouchPoint(
//      id: 117,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.52,
//        y: 0.58
//      ),
//      timestamp: 2.64,
//      velocity: CGVector(
//        dx: -1.0,
//        dy: 1.0
//      ),
//      pressure: 0.77
//    ),
//    TouchPoint(
//      id: 118,
//      phase: .moved,
//      position: CGPoint(
//        x: 0.5,
//        y: 0.6
//      ),
//      timestamp: 2.66,
//      velocity: CGVector(
//        dx: -1.0,
//        dy: 1.0
//      ),
//      pressure: 0.8
//    ),
//  ]
//
}
