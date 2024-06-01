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
import Popup

struct SingleMessageView: View {
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var popup: PopupHandler
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
            VStack(alignment: .leading, spacing: 20) {
                                Text(highlighted)
                                    .foregroundStyle(.primary.opacity(0.9))
                                    .font(.system(size: 15, weight: .medium))
//                MarkdownEditorView(
//                    text: $message.content,
//                    placeholderText: "",
//                    isFocused: $isFocused,
//                    isEditable: false
//                )
                
                HStack(alignment: .bottom, spacing: 18) {
                    Label("\((message.promptTokens ?? 0) + (message.completionTokens ?? 0))", systemImage: Icons.token.icon)
                    
                    Label("\(message.content.count)", systemImage: "textformat.alt")
                    Label("\(message.content.wordCount)", systemImage: "text.word.spacing")
                    
                    Spacer()
                    
                    Button {
                        copyStringToClipboard(message.content)
                        popup.showPopup(title: "Message copied to clipboard")
                    } label: {
                        Label("Copy text", systemImage: Icons.copy.icon)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.customButton(size: .small, labelDisplay: .iconOnly))
                }
                .opacity(isHovering ? 1.0 : 0.4)
                .labelStyle(.customLabel(size: .mini))
                .padding(.horizontal, Styles.paddingNSTextViewCompensation)
                
            } // END inner vstack
//            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .frame(maxWidth: 620, alignment: .leading)
            .background(Color(message.type == .user ? Swatch.eggplant.colour.opacity(0.2) : .gray.opacity(0.2)))
            .clipShape(.rect(cornerRadius: Styles.roundingMedium))
            .onHover { hovering in
                
                if hovering {
                    withAnimation(Styles.animation) {
                        isHovering = true
                    }
                } else {
                    withAnimation(Styles.animationEasedSlow) {
                        isHovering = false
                    }
                }
                
            }
            .padding(.leading, message.type == .user ? authorAltPadding : 0)
            .padding(.trailing, message.type == .user ? 0 : authorAltPadding)
            .padding(.bottom, 40)
            
//            .overlay(alignment: .topTrailing) {
//                if isHovering {
//                   
//                }
//            }
//            
//            
            
            //            .frame(maxWidth: 620)
            //            .onTapGesture {
            //                withAnimation(Styles.animationQuick) {
            //                    isHovering.toggle()
            //                }
            //            }
            
        } // END outer vstack
        .padding(.horizontal, Styles.paddingText + Styles.paddingNSTextViewCompensation)
        .frame(maxWidth: .infinity, alignment: message.type == .user ? .trailing : .leading)
    }
    
}

#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SingleMessageView(message: Message(content: ExampleText.paragraphs[3]))
            .environmentObject(BanksiaHandler())
            .environmentObject(SidebarHandler())
            .environmentObject(PopupHandler())
            .environment(ConversationHandler())
            .frame(width: 500, height: 700)
    }
}

#endif
