//
//  OptionalShortcutView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/8/2025.
//

import SwiftUI

public struct OptionalShortcutView<Content: View>: View {

  let shortcut: KeyboardShortcut?
  let content: Content

  public init(
    _ shortcut: KeyboardShortcut?,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.shortcut = shortcut
    self.content = content()
  }

  public var body: some View {
    if let shortcut {
      content
        .keyboardShortcut(shortcut)
    } else {
      content
    }
  }
}
