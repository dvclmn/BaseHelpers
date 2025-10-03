//
//  KeyPressCommand.swift
//  BaseComponents
//
//  Created by Dave Coleman on 14/5/2025.
//

import SwiftUI

public struct KeyPressCommandModifier<CommandHandler: KeyPressCommandHandler, Command: KeyPressable>: ViewModifier where CommandHandler.Command == Command {

  let commandHandler: CommandHandler
  let isFocusEffectDisabled: Bool
  @FocusState private var isFocused: Bool
//  @FocusState private var isFocused: Bool

//  @FocusedBinding var focusedBinding: FocusState<Bool>.Binding?
  
  public func body(content: Content) -> some View {
    content
      .focusable(true)
      .focused($isFocused)
      .focusEffectDisabled(isFocusEffectDisabled)
//      .onAppear {
//        isFocused = true
//      }
      .onKeyPress { keyPress in
        return handleKeyPress(keyPress.key)
      }
  }
}
extension KeyPressCommandModifier {
  private func handleKeyPress(_ key: KeyEquivalent) -> KeyPress.Result {
    if let command = Command.fromKey(key) {
      commandHandler.handleCommand(command)
      return .handled
    }
    return .ignored
  }
}
extension View {
  public func keyPressCommands<T: KeyPressCommandHandler>(
    _ handler: T,
    isFocusEffectDisabled: Bool = true
  ) -> some View {
    self.modifier(
      KeyPressCommandModifier(
        commandHandler: handler,
        isFocusEffectDisabled: isFocusEffectDisabled
      )
    )
  }
}
