//
//  CharacterWidth.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import SwiftUI

//public struct CharacterWidth {
//  var fontStyle: Font.TextStyle
//
//  public var width: CGFloat {
//    let testCharacter: Character = "0"
//
//  }
//}


public struct CharacterSize: ViewModifier {
//  @State private var characterWidth: CGFloat = .zero
  let character: Character
  let fontStyle: Font
  let widthDidChange: (CGFloat) -> Void
  public func body(content: Content) -> some View {
    content
      .overlay {
        VStack {
          Text(character.toString)
            .font(fontStyle)
            .viewSize(mode: .debounce(0.1)) { size in
              widthDidChange(size.width)
            }
            .hidden()
        }
        .allowsHitTesting(false)
      }
  }
}
extension View {
  public func characterWidth(
    _ testCharacter: Character = "0",
    fontStyle: Font,
    _ widthDidChange: @escaping (CGFloat) -> Void
  ) -> some View {
    self.modifier(
      CharacterSize(
        character: testCharacter,
        fontStyle: fontStyle,
        widthDidChange: widthDidChange
      )
    )
  }
}
