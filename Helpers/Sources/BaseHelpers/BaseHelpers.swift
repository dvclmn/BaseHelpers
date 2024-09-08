// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI



/// Usage
/// From this:
/// ```swift
/// if textView.string != self.text {
///    textView.string = self.text
/// }
/// ```
/// To this: `textView.string ?= self.text`
///
infix operator ?=: AssignmentPrecedence

public func ?=<T: Equatable>(lhs: inout T, rhs: T) {
  if lhs != rhs {
    lhs = rhs
  }
}

// MARK: - Random colour
public extension ShapeStyle where Self == Color {
  static var random: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}

// MARK: - Visual effect
#if os(macOS)
public struct VisualEffectView: NSViewRepresentable {
  public func makeNSView(context: Context) -> NSView {
    let view = NSVisualEffectView()
    view.blendingMode = .behindWindow
    view.state = .active
    view.material = .underWindowBackground
    return view
  }
  public func updateNSView(_ view: NSView, context: Context) { }
}
#endif


// MARK: - Check if is Preview
public var isPreview: Bool {
  return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}



public func downloadImage(from url: URL) async throws -> Data {
  let (data, response) = try await URLSession.shared.data(from: url)
  
  // Check for a valid HTTP response
  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    throw URLError(.badServerResponse)
  }
  return data
}



#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif


public extension Image {
  init?(data: Data) {
#if canImport(UIKit)
    guard let uiImage = UIImage(data: data) else { return nil }
    self.init(uiImage: uiImage)
#elseif canImport(AppKit)
    guard let nsImage = NSImage(data: data) else { return nil }
    self.init(nsImage: nsImage)
#endif
  }
}

//#if canImport(UIKit)
//extension UIImage {
//    var cgImage: CGImage? {
//        return self.cgImage
//    }
//}
//#endif

#if canImport(AppKit)
public extension NSImage {
  var cgImage: CGImage? {
    var rect = CGRect(origin: .zero, size: self.size)
    return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
  }
}
#endif



//public extension Double {
//  var wholeNumber: String {
//    return toDecimalPlace(self, to: 0)
//  }
//  func toDecimal(_ place: Int) -> String {
//    return toDecimalPlace(self, to: place)
//  }
//}


public extension Int64 {
  func getString() -> String {
    return String(self)
  }
}

extension UUID: @retroactive RawRepresentable {
  public var rawValue: String {
    self.uuidString
  }
  
  public typealias RawValue = String
  
  public init?(rawValue: RawValue) {
    self.init(uuidString: rawValue)
  }
}
