//
//  Model+LayoutType.swift
//  BaseComponents
//
//  Created by Dave Coleman on 20/9/2025.
//

import SwiftUI

public enum LayoutType {
  case hstack(alignment: VerticalAlignment = .center)
  case vstack(alignment: HorizontalAlignment = .center)
  case grid(alignment: Alignment = .center, horizontalSpacing: CGFloat? = nil)
  case passthrough

  public init(fromAxis axis: Axis?) {

    switch axis {
      case .horizontal:
        self = .hstack()

      case .vertical:
        self = .vstack()

      case nil:
        self = .passthrough
    }

  }

  /// Creates a concrete Layout based on layout type.
  /// - Parameter spacing: For `hstack` & `vstack`, this is supplied to their
  /// `spacing` parameter. For `grid`, this is supplied to `verticalSpacing`.
  /// Grid's `horizontalSpacing` is handled in the associated value
  /// - Returns: A layout usable in a SwiftUI view.
  public func toLayout(
    spacing: CGFloat? = nil
  ) -> AnyLayout? {
    switch self {
      case .hstack(let alignment):
        AnyLayout(
          HStackLayout(
            alignment: alignment,
            spacing: spacing
          )
        )
      case .vstack(let alignment):
        AnyLayout(
          VStackLayout(
            alignment: alignment,
            spacing: spacing
          )
        )
      case .grid(let alignment, let spacingH):
        AnyLayout(
          GridLayout(
            alignment: alignment,
            horizontalSpacing: spacingH,
            verticalSpacing: spacing
          )
        )

      case .passthrough: nil
    }
  }
}

public enum LayoutMode: String, Cyclable, Codable, Sendable, RawRepresentable {
  public static var defaultCase: LayoutMode { .list }
  
  case grid
  case list
  
  public var label: QuickLabel {
    QuickLabel(rawValue.capitalized, icon: .symbol(iconString))
  }
  
  public var iconString: String {
    switch self {
      case .grid: "circle.grid.2x2"
      case .list: "checklist.unchecked"
    }
  }
  
  public var isGrid: Bool {
     self == .grid
  }
  public var isList: Bool {
    self == .list
  }
}

#warning("Is the below still useful?")
//public struct LayoutToggle: View {
//  
//  @Binding var mode: LayoutMode
//  
//  public init(_ mode: Binding<LayoutMode>) {
//    self._mode = mode
//  }
//  public var body: some View {
//    
//    Button {
//      mode.moveForward()
//    } label: {
//      MaybeLabel(mode.label)
//    }
//    
//  }
//}
