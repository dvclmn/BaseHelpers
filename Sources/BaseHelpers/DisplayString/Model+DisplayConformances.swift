//
//  Model+DisplayConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import SwiftUI

extension Double: SingleValueStringable {
  public var value: Double { self }
}
extension CGFloat: SingleValueStringable {
  public var value: Double { self.toDouble }
}

extension CGPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: DisplayPairValueLabel { .init("X") }
  public var valueBLabel: DisplayPairValueLabel { .init("Y") }
}


extension CGSize: DisplayPair {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var valueALabel: DisplayPairValueLabel { .init("W", "Width") }
  public var valueBLabel: DisplayPairValueLabel { .init("H", "Height") }
}
extension CGVector: DisplayPair {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var valueALabel: DisplayPairValueLabel { .init("DX") }
  public var valueBLabel: DisplayPairValueLabel { .init("DY") }

}
extension UnitPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: DisplayPairValueLabel { .init("X") }
  public var valueBLabel: DisplayPairValueLabel { .init("Y") }
}
