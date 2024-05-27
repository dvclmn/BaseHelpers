//
//  ConversationView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData
import GeneralStyles
import GeneralUtilities
import Icons
import Button

struct ConversationView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var pref: Preferences
    @Environment(\.modelContext) private var modelContext
    
    @Query private var messages: [Message]
    
    @Bindable var conversation: Conversation
    @Binding var scrolledMessageID: Message.ID?
    
    var body: some View {
        
        @Bindable var conv = conv
        @Bindable var bk = bk
        
        VStack {
            if let conversationMessages = conversation.messages {
                
                var searchResults: [Message] {
                    conversationMessages.filter { message in
                        if conv.searchText.count > 1 {
                            return message.content.localizedCaseInsensitiveContains(conv.searchText)
                        } else {
                            return true
                        }
                    }
                }
                
                VStack {
                    if conversationMessages.count > 0 {
                        
                        if searchResults.count > 0 {
                            
                            
                            
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 12) {
                                    ForEach(searchResults.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                                        
                                        SingleMessageView(
                                            message: message
                                        )
                                        .id(message.id)
                                        
                                    } // END ForEach
                                } // END lazy vstack
                                .scrollTargetLayout()
                                .padding(.vertical, 40)
                            } // END scrollview
                            .scrollPosition(id: $scrolledMessageID, anchor: .top)
                            .safeAreaPadding(.top, Styles.toolbarHeight)
                            .safeAreaPadding(.bottom, conv.editorHeight + 10)
                            
                            .overlay(alignment: .bottomTrailing) {
                                Button {
                                    scrolledMessageID = searchResults.last?.id
                                } label: {
                                    Label("Scroll to latest message", systemImage: Icons.down.icon)
                                }
                                .buttonStyle(.customButton(size: .small, labelDisplay: .iconOnly))
                                .padding(.bottom, conv.editorHeight + Styles.paddingSmall)
                                .padding(.trailing, Styles.paddingSmall)
                            } // END scroll to bottom
                            
                        } else {
                            EmptyMessage("No matching results", message: "No results found for \"\(conv.searchText)\".")
                        }
                        
                    } else {
                        EmptyMessage("No messages yet")
                    } // END message count check
                } // END vstack
                //                .cursor(.arrow)
                
                .overlay(alignment: .bottom) {
                    MessageInputView(
                        conversation: conversation
                    )
                }
                
                .sheet(isPresented: $conv.isConversationEditorShowing) {
                    
                    ConversationEditorView(conversation: conversation)
                    
                }
                
                .overlay {
                    QuickNavView()
                }
                
                
            } // END has messages check
            
            
        } // Vstack so I can do an onAppear?
        .task(id: conversation.grainientSeed) {
            withAnimation(Styles.animationRelaxed) {
                conv.grainientSeed = conversation.grainientSeed
            }
        }
        
        
    } // END view body
    
    //    private func scrollToNextID() {
    //        print("Let's scroll to next")
    //
    //        guard let messages = conversation.messages else {
    //            print("Couldn't get first convo's messages")
    //            return
    //        }
    //
    //        guard let id = messageID else {
    //            print("Couldn't get id to equal message")
    //            return
    //        }
    //
    //        guard id != messages.last?.id else {
    //            print("id ended up being the same as messages.last")
    //            return
    //        }
    //
    //        guard let index = messages.firstIndex(where: { $0.id == id }) else {
    //            print("couldn't get index to equal the first message where the message ID matched the `messageID` binding")
    //            return
    //        }
    //
    //
    //        withAnimation {
    //            messageID = messages[index + 1].id
    //            print(messageID ?? UUID())
    //        }
    //    }
    
    //    private func scrollToPreviousID() {
    //        print("Let's scroll to next")
    //
    //        guard let messages = conversation.messages else {
    //            print("Couldn't get first convo's messages")
    //            return
    //        }
    //
    //        guard let id = messageID, id != messages.first?.id,
    //              let index = messages.firstIndex(where: { $0.id == id })
    //        else {
    //            print("Couldn't get that complex stuff")
    //            return
    //        }
    //
    //        withAnimation {
    //            messageID = messages[index - 1].id
    //            print(messageID ?? UUID())
    //        }
    //    }
    
    
}
extension ConversationView {
    @ViewBuilder
    func EmptyMessage(
        _ title: String,
        message: String? = nil
    ) -> some View {
        VStack(spacing: 14) {
            Text(title)
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(.tertiary)
            if let message = message {
                Text(message)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, Styles.toolbarHeight / 2)
        .padding(.bottom, conv.editorHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

