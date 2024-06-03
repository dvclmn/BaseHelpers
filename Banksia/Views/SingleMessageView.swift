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

    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @State private var isHovering: Bool = false
    
    var conversation: Conversation
    
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
                
//                Label(message.type.name, systemImage: message.type.defaultIcon)
//                    .labelStyle(.customLabel())
                
//                Text(highlighted)
//                    .foregroundStyle(.primary.opacity(0.9))
//                    .font(.system(size: 15, weight: .medium))
//                    .textSelection(.enabled)
                
                                MarkdownEditorView(
                                    text: $message.content,
                                    placeholderText: "",
                                    isFocused: $isFocused,
                                    isEditable: false
                                )
                
                if pref.isMessageInfoShowing {
                    
//                    Button {
//                        message.content += "butts "
//                    } label: {
//                        Label("Add text", systemImage: Icons.text.icon)
//                    }
                    
                    HStack(alignment: .bottom, spacing: 14) {

                        
                        Label("\(message.type.name)", systemImage: message.type.defaultIcon)
                        
                        
                        Label("\(conv.getMessageTimestamp(message.timestamp))", systemImage: Icons.clock.icon)
                        
                        Label("\((message.promptTokens ?? 0) + (message.completionTokens ?? 0))", systemImage: Icons.token.icon)
                        
                        Label("\(message.content.wordCount)", systemImage: "text.word.spacing")
                        Label("\(message.content.count)", systemImage: "textformat.alt")
                        
                        Spacer()
                        
                        Button {
                            copyStringToClipboard(message.content)
                            popup.showPopup(title: "Message copied to clipboard")
                        } label: {
                            Label("Copy text", systemImage: Icons.copy.icon)
                        }
                        .buttonStyle(.customButton(size: .mini, hasBackground: false, labelDisplay: .iconOnly))
                        .offset(x: 6, y: 3)
                    }
                    .opacity(isHovering ? 1.0 : 0.4)
                    .labelStyle(.customLabel(size: .mini))
                    .padding(.horizontal, Styles.paddingNSTextViewCompensation)
                    
                    
                }
                
            } // END inner vstack
            //            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .frame(maxWidth: 620, alignment: .leading)
            .background(Color(message.type == .user ? Swatch.eggplant.colour.opacity(0.2) : .gray.opacity(0.2)))
            .clipShape(.rect(cornerRadius: Styles.roundingMedium))
            .onHover { hovering in
                
                if hovering {
                    withAnimation(Styles.animationQuick) {
                        isHovering = true
                    }
                } else {
                    withAnimation(Styles.animationEased) {
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

//        .task(id: conv.streamingGPTMessageTimestamp) {
//            if message.timestamp == conv.streamingGPTMessageTimestamp {
//                print("The single message time, *did* match the streamed message time!")
//                
//                message.content += conv.streamedResponse
//            } else {
//                print("The single message time, did not match the streamed message time")
//                print("The single message ID:\n\(message.persistentModelID), did not match the streamed message ID:\n\(String(describing: conv.streamingGPTMessageID))")
//            }
//        }
//        .task {
//            guard let gptMessage = message.first(where: {$0.timestamp == conv.streamingGPTMessageTimestamp}).content else {
//                print("Couldn't get a matching message to stream to")
//            }
            
//            message.content += conv.streamedResponse
//        }
    }
    
}

extension SingleMessageView {
    
    
    
}

#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SingleMessageView(
            conversation: Conversation.appKitDrawing,
            message: Message(content: ExampleText.paragraphs[3])
        )
        .environment(BanksiaHandler())
        .environmentObject(SidebarHandler())
        .environmentObject(PopupHandler())
        .environment(ConversationHandler())
        .frame(width: 500, height: 700)
    }
}

#endif
