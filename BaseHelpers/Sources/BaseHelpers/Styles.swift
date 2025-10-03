// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public struct Styles {
  
  public static let sidebarSizes: (CGFloat, CGFloat, CGFloat) = (280, 380, 520)
  public static let inspectorSizes: (CGFloat, CGFloat, CGFloat) = (280, 380, 520)
  
  public static let customButtonHeight: CGFloat = 21

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
  public static let infoBarDefaultHeight: Double = 38
  public static let overScroll: Double = 200

  /// Padding

  
// sizePico: Double = 2
// sizeNano: Double = 2
// sizeMicro: Double = 3
// sizeMilli: Double = 4
// sizeTiny: Double = 5
// sizeSmall: Double = 8
// sizeRegular: Double = 13
// sizeMedium: Double = 21
// sizeLarge: Double = 34
// sizeHuge: Double = 55
// sizeGiant: Double = 89
// sizeMassive: Double = 144
  
  
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
  
  public static let glassRounding: Double = 26

  public static let paddingToolbarTrafficLightsWidth: Double = 82
  public static let paddingToMatchList: Double = 16
  public static let paddingToMatchForm: Double = 22
  public static let paddingToolbarHorizontal: Double = 18
  public static let paddingNSTextViewCompensation: Double = 5

  /// # Animation
  /// Responsive — easeOut = quick at the start, slower at the end
  public static let animation: Animation =
    .easeOut(duration: 0.2)
  
  public static let animationQuick: Animation =
    .easeOut(duration: 0.08)

  // MARK: - Ease InOut
  public static let animationEased: Animation =
    .easeInOut(duration: 0.35)
  
  public static let animationEasedQuick: Animation =
    .easeInOut(duration: 0.15)
  
  public static let animationEasedSlow: Animation =
    .easeInOut(duration: 0.6)

  // MARK: - Smooth
  public static let animationSmooth: Animation =
    .smooth(duration: 0.35, extraBounce: 0.15)
  
  public static let animationSmoother: Animation =
    .smooth(duration: 0.8, extraBounce: 0.20)
  
  public static let animationSmoothest: Animation =
    .smooth(duration: 1.2, extraBounce: 0.25)
  
  public static let animationQuickNSmooth: Animation =
    .smooth(duration: 0.25, extraBounce: 0.2)
  
  public static let animationExtraQuickNSmooth: Animation =
    .smooth(duration: 0.1, extraBounce: 0.2)

  public static let animationRelaxed: Animation =
    .smooth(duration: 2.8, extraBounce: 0.45)
  
  public static let animationRelaxedSubtle: Animation =
    .smooth(duration: 3.2, extraBounce: 0.25)

  // MARK: - Springy
  public static let animationBounce: Animation =
    .bouncy(duration: 0.3, extraBounce: 0.5)
  
  public static let animationSpring: Animation =
    .snappy(duration: 0.4, extraBounce: 0.5)
  
  public static let animationSpringSubtle: Animation =
    .snappy(duration: 0.35, extraBounce: 0.2)
  
  public static let animationSpringExtraSubtle: Animation =
    .snappy(duration: 0.3, extraBounce: 0.1)
  
  public static let animationSpringExtraBouncy: Animation =
    .snappy(duration: 0.28, extraBounce: 0.45)
  
  public static let animationSpringExtraBouncyRelaxed: Animation =
    .snappy(duration: 0.48, extraBounce: 0.48)
  
  public static let animationSpringQuick: Animation =
    .snappy(duration: 0.2, extraBounce: 0.15)
  
  public static let animationSpringQuickNBouncy: Animation =
    .snappy(duration: 0.2, extraBounce: 0.35)
  
  public static let animationSpringQuickNSubtle: Animation =
    .snappy(duration: 0.22, extraBounce: 0.06)
  
  public static let animationSpringExtraQuick: Animation =
    .snappy(duration: 0.08, extraBounce: 0.1)

  // MARK: - Looping
  public static let animationLoop: Animation =
    .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
  
  public static let animationLoopSlow: Animation =
    .easeInOut(duration: 4.6).repeatForever(autoreverses: true)

}

//extension Styles {
//  static let sizes: [Double] = [
//    Styles.sizeNano,
//    Styles.sizeNano.bump,
//    Styles.sizeMicro,
//    Styles.sizeMicro.bump,
//    Styles.sizeTiny,
//    Styles.sizeTiny.bump,
//    Styles.sizeSmall,
//    Styles.sizeSmall.bump,
//    Styles.sizeRegular,
//    Styles.sizeRegular.bump,
//    Styles.sizeMedium,
//    Styles.sizeMedium.bump,
//    Styles.sizeLarge,
//    Styles.sizeLarge.bump,
//    Styles.sizeHuge,
//    Styles.sizeHuge.bump,
//    Styles.sizeGiant,
//    Styles.sizeGiant.bump,
//    Styles.sizeMassive,
//    Styles.sizeMassive.bump,
//  ]
//}
