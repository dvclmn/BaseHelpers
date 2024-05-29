//
//  SingleMessageView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
import GeneralStyles
import GeneralUtilities
import Icons
import Sidebar
import MarkdownEditor
import Swatches

struct SingleMessageView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var sidebar: SidebarHandler
    
    @State private var isHovering: Bool = false
    
    @Bindable var message: Message
    
    let messageMaxWidth: Double = 300
    
    
    
    @FocusState private var isFocused
    
    var body: some View {
        
        var authorAltPadding: Double {
            if sidebar.windowSize.width < 600 {
                return 20
            } else {
                return 80
            }
        }
        
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
//                Text(highlighted)
//                    .foregroundStyle(.primary.opacity(0.9))
//                    .font(.system(size: 15, weight: .medium))
                MarkdownEditorView(
                    text: $message.content,
                    placeholderText: "",
                    isFocused: $isFocused,
                    isEditable: false
                )
                .fixedSize(horizontal: false, vertical: true)                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(message.type == .user ? Swatch.eggplant.colour.opacity(0.2) : .gray.opacity(0.2)))
                .clipShape(.rect(cornerRadius: Styles.roundingMedium))
                .padding(.leading, message.type == .user ? authorAltPadding : 0)
                .padding(.trailing, message.type == .user ? 0 : authorAltPadding)
                .padding(.bottom, 40)
                
                .overlay(alignment: .topTrailing) {
                    if isHovering {
                        Button {
                            copyStringToClipboard(message.content)
                        } label: {
                            Label("Copy text", systemImage: Icons.copy.icon)
                        }
                        .buttonStyle(.customButton(size: .mini, labelDisplay: .iconOnly))
                        .padding(8)
                    }
                }
                
            } // END inner vstack
            .frame(maxWidth: 620)
            .onTapGesture {
                withAnimation(Styles.animationQuick) {
                    isHovering.toggle()
                }
            }
            
        } // END outer vstack
        .padding(.horizontal, Styles.paddingText + Styles.paddingNSTextView)
        .frame(maxWidth: .infinity, alignment: message.type == .user ? .trailing : .leading)
    }
    
}

#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SingleMessageView(message: Message.response_02)
            .environment(BanksiaHandler())
            .environment(ConversationHandler())
            .frame(width: 500, height: 700)
    }
}

#endif
