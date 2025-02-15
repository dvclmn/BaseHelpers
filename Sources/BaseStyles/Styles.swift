// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

extension Double {
  public var bump: Double {
    let nextFib = self * 1.618
    /// Approximate next Fibonacci number
    return (self + nextFib) / 2/// Midpoint between current and next
  }
}

public struct Styles {

  /// Sidebar
  public static let sidebarToggleBuffer: Double = 80


  public static let minContentWidth: Double = 440
  public static let minContentHeight: Double = 600
  public static let readingWidth: Double = 580
  public static let readingWidthDialogue: Double = 360


  public static let navBarHeightLarge: Double = 60
  public static let navBarHeightInline: Double = 40
  public static let tabBarHeight: Double = 60

  /// Toolbar
  public static let toolbarHeightLarge: Double = 74
  public static let toolbarHeightPrimary: Double = 52
  public static let toolbarHeightSecondary: Double = 46
  public static let toolbarHeightTertiary: Double = 34
  public static let toolbarHeightQuaternary: Double = 26
  public static let toolbarHeightQuinary: Double = 22

  /// Info bar
  public static let infoBarHeight: Double = 24


  public static let titleBarHeight: Double = 26

  public static let hBarDefaultHeight: Double = 38

  public static let overScroll: Double = 200

  /// Padding


  public static let sizeNano: Double = 2
  public static let sizeMicro: Double = 3
  public static let sizeTiny: Double = 5
  public static let sizeSmall: Double = 8
  public static let sizeRegular: Double = 13
  public static let sizeMedium: Double = 21
  public static let sizeLarge: Double = 34
  public static let sizeHuge: Double = 55
  public static let sizeGiant: Double = 89
  public static let sizeMassive: Double = 144

  public static let paddingToolbarTrafficLightsWidth: Double = 82
  public static let paddingToMatchList: Double = 16
  public static let paddingToMatchForm: Double = 22
  public static let paddingToolbarHorizontal: Double = 18
  public static let paddingNSTextViewCompensation: Double = 5


  /// # Animation
  /// Responsive — easeOut = quick at the start, slower at the end
  public static let animation: Animation = .easeOut(duration: 0.2)
  public static let animationQuick: Animation = .easeOut(duration: 0.08)

  /// Smooth at both ends
  public static let animationEased: Animation = .easeInOut(duration: 0.35)
  public static let animationEasedQuick: Animation = .easeInOut(duration: 0.15)
  public static let animationEasedSlow: Animation = .easeInOut(duration: 0.6)

  public static let animationSmooth: Animation = .smooth(duration: 0.35, extraBounce: 0.15)
  public static let animationQuickNSmooth: Animation = .smooth(duration: 0.25, extraBounce: 0.2)

  public static let animationRelaxed: Animation = .smooth(duration: 2.8, extraBounce: 0.45)

  /// Dynamic — springs and bounces
  public static let animationBounce: Animation = .bouncy(duration: 0.3, extraBounce: 0.5)
  public static let animationSpring: Animation = .snappy(duration: 0.4, extraBounce: 0.5)
  public static let animationSpringSubtle: Animation = .snappy(duration: 0.35, extraBounce: 0.2)
  public static let animationSpringExtraSubtle: Animation = .snappy(duration: 0.3, extraBounce: 0.1)
  public static let animationSpringExtraBouncy: Animation = .snappy(
    duration: 0.28, extraBounce: 0.45)
  public static let animationSpringQuick: Animation = .snappy(duration: 0.2, extraBounce: 0.15)
  public static let animationSpringQuickNBouncy: Animation = .snappy(
    duration: 0.2, extraBounce: 0.35)
  public static let animationSpringQuickNSubtle: Animation = .snappy(
    duration: 0.22, extraBounce: 0.06)
  public static let animationSpringExtraQuick: Animation = .snappy(duration: 0.08, extraBounce: 0.1)

  public static let animationLoop: Animation = .easeInOut(duration: 0.6).repeatForever(
    autoreverses: true)
  public static let animationLoopSlow: Animation = .easeInOut(duration: 4.6).repeatForever(
    autoreverses: true)


}


extension Styles {
  static let sizes: [Double] = [
    Styles.sizeNano,
    Styles.sizeNano.bump,
    Styles.sizeMicro,
    Styles.sizeMicro.bump,
    Styles.sizeTiny,
    Styles.sizeTiny.bump,
    Styles.sizeSmall,
    Styles.sizeSmall.bump,
    Styles.sizeRegular,
    Styles.sizeRegular.bump,
    Styles.sizeMedium,
    Styles.sizeMedium.bump,
    Styles.sizeLarge,
    Styles.sizeLarge.bump,
    Styles.sizeHuge,
    Styles.sizeHuge.bump,
    Styles.sizeGiant,
    Styles.sizeGiant.bump,
    Styles.sizeMassive,
    Styles.sizeMassive.bump,
  ]
}
