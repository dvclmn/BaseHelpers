//
//  SingleMessageView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
import Styles
import Utilities

struct SingleMessageView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @State private var isHovering: Bool = false
    
    @Bindable var message: Message
    
    let messageMaxWidth: Double = 300
    
    var body: some View {
        
        var match: [String] {
            return [conv.searchText].filter { message.content.localizedCaseInsensitiveContains($0) }
        }
        
        var highlighted: AttributedString {
            var result = AttributedString(message.content)
            _ = match.map {
                let ranges = message.content.ranges(of: $0, options: [.caseInsensitive])
                ranges.forEach { range in
                    result[range].backgroundColor = .orange.opacity(0.2)
                }
            }
            return result
        }
        
        
        VStack {
            VStack {
                
                
                //                Markdown {
                //                    message.content
                //                }
//                Text(highlighted)
                StylableTextEditorRepresentable(text: $message.content, isEditable: false)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(message.type == .user ? .blue : .gray).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: Styles.roundingMedium))
//                    .markdownTheme(.gitHubCustom)
                    .id(message.timestamp)
                
//                    .contextMenu {
//                        Button {
//                            
//                        } label: {
//                            Label("Delete message", systemImage: Icons.arrowDown.icon)
//                        }
//                    }
//                    .textSelection(.enabled)
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
            .padding(Styles.paddingText)
            
            
            
            .onHover { hovering in
                isHovering = hovering
            }
        }
//        .font(.system(size: 14))
        .frame(maxWidth: .infinity, alignment: message.type == .user ? .trailing : .leading)
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
        SingleMessageView(message: Message.response_02)
            .environment(BanksiaHandler())
            .environment(ConversationHandler())
            .frame(width: 500, height: 700)
    }
}
