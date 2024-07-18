// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct RenamableModifier: ViewModifier {
    
    @State private var localLabel: String = ""
    @FocusState private var isRenameFieldFocused: Bool
    
    @Binding var isRenaming: Bool
    let itemName: String
    let renameAction: (String) -> Void
    let textfieldLabel: String
    
    public func body(content: Content) -> some View {
        Group {
            if isRenaming {
                TextField(textfieldLabel, text: $localLabel)
//                    .textFieldStyle(.customField(text: $localLabel))
                    .focused($isRenameFieldFocused)
                    .onSubmit {
                        rename()
                    }
                    .onChange(of: isRenameFieldFocused) {
                        isRenaming = isRenameFieldFocused
                    }
                    .onAppear {
                        isRenameFieldFocused = true
                        localLabel = itemName
                    }
                #if os(macOS)
                    .onExitCommand {
                        isRenameFieldFocused = false
                        isRenaming = false
                        localLabel = ""
                    }
                #endif
            } else {
                content
//                    .gesture(TapGesture(count: 2).onEnded {
//                        isRenaming = true
//                    })
            }
        }
    }
    
    private func rename() {
        isRenaming = false
        renameAction(localLabel)
    }
}

public extension View {
    func renamable(
        isRenaming: Binding<Bool>,
        itemName: String,
        renameAction: @escaping (String) -> Void,
        textfieldLabel: String = "Rename item"
    ) -> some View {
        self.modifier(
            RenamableModifier(
                isRenaming: isRenaming,
                itemName: itemName,
                renameAction: renameAction,
                textfieldLabel: textfieldLabel
            )
        )
    }
}
