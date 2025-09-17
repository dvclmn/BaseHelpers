//
//  SmallStateView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct MiniStateView: View {

  let text: String

  init(_ text: String) {
    self.text = text
  }
  public var body: some View {
    Text(text)
      .font(.callout.weight(.medium))
      .foregroundStyle(.secondary.opacity(0.8))

  }
}
