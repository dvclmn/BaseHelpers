//
//  Model+DisplayConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import SwiftUI

extension Double: StringConvertibleFloat {
  public var value: Double { self }
}
extension CGFloat: StringConvertibleFloat {
  public var value: Double { self.toDouble }
}

extension CGPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var labelA: DisplayPairValueLabel { .init("X") }
  public var labelB: DisplayPairValueLabel { .init("Y") }
}

extension CGSize: DisplayPair {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var labelA: DisplayPairValueLabel { .init("W", "Width") }
  public var labelB: DisplayPairValueLabel { .init("H", "Height") }
}
extension CGVector: DisplayPair {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var labelA: DisplayPairValueLabel { .init("DX") }
  public var labelB: DisplayPairValueLabel { .init("DY") }

}
extension UnitPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var labelA: DisplayPairValueLabel { .init("X") }
  public var labelB: DisplayPairValueLabel { .init("Y") }
}
extension UnitPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var labelA: DisplayPairValueLabel { .init("X") }
  public var labelB: DisplayPairValueLabel { .init("Y") }
}
