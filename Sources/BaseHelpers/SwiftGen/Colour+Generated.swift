// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen


#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs



// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset: String, Codable, CaseIterable, Identifiable, Sendable, Hashable, Equatable {
  public enum Swatch: Sendable {
      case asciiBlack
      case asciiBlue
      case asciiBrown
      case asciiGreen
      case asciiGrey
      case asciiMaroon
      case asciiPurple
      case asciiRed
      case asciiTeal
      case asciiTealDull
      case asciiWarmWhite
      case asciiWhite
      case asciiYellow
      case blackTrue
      case blue10
      case blue20
      case blue30
      case blue40
      case blue50
      case blue60
      case brown30
      case brown40
      case brown50
      case brown60
      case green20
      case green30V
      case green50
      case green70
      case grey05
      case grey10
      case grey20
      case grey30
      case grey40
      case grey80
      case grey90
      case lime30
      case lime40
      case neonGreen
      case neonOrange
      case neonPink
      case neonYellow
      case olive40
      case olive70
      case orange30
      case peach20
      case peach30
      case peach30V
      case peach40
      case plum30
      case plum40
      case plum50
      case plum60
      case plum70
      case plum80
      case plum90
      case purple20
      case purple30
      case purple40
      case purple50
      case purple70
      case red50
      case red50V
      case slate30
      case slate40
      case slate50
      case slate60
      case slate70
      case slate80
      case slate90
      case teal30
      case teal50
      case whiteBone
      case whiteOff
      case whiteTrue
      case yellow30
      case yellow40
  }

}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details


// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
