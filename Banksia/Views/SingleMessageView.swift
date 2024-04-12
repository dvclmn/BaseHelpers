//
//  SingleMessageView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData

struct SingleMessageView: View {
    
    @State private var isHovering: Bool = false

    var message: Message
    
    var body: some View {
        VStack {
            VStack {
                
                Text(message.content)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding()
                    .id(message.timestamp)
                    .contextMenu {
                        Button {
                            
                        } label: {
                            Label("Delete message", systemImage: Icons.arrowDown.icon)
                        }
                    }
                    .textSelection(.enabled)
                    .overlay(alignment: .topTrailing) {
                        if isHovering {
                            Button {
                                copyToClipboard(message.content)
                            } label: {
                                Label("Copy text", systemImage: Icons.copy.icon)
                                    .labelStyle(.iconOnly)
                            }
                            .padding(8)
                        }
                    }
                
            }
            .frame(maxWidth: 500)
            .background(Color(message.isUser ? .blue : .gray).opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: Styles.roundingMedium))
            .onHover { hovering in
                isHovering = hovering
            }
        }
        .font(.system(size: 14))
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard: PasteboardCopying
#if canImport(AppKit)
        pasteboard = NSPasteboard.general
#elseif canImport(UIKit)
        pasteboard = UIPasteboard.general
#endif
        pasteboard.setString("\(text)")
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SingleMessageView(message: Message.prompt_02)
        .frame(width: 700, height: 700)
    }
}
