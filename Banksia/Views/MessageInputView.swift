//
//  MessageInputView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
import Styles
import Utilities
import Modifiers
import Swatches
import ResizableView

struct MessageInputView: View {
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var pref: Preferences
    @Environment(\.modelContext) private var modelContext
    
    @SceneStorage("userPrompt") var userPrompt: String = ""
    
    @SceneStorage("isTesting") var isTesting: Bool = true
    
    @State private var isHoveringHeightAdjustor: Bool = false
    
    let minInputHeight: Double = 200
    let maxInputHeight: Double = 500
    
    
    let inputHeightControlSize: Double = 12
    
    @FocusState private var isFocused
    
    var conversation: Conversation

    var body: some View {
        
        @Bindable var conv = conv
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                ResizableView(
                    size: $conv.editorHeight,
                    minSize: 200,
                    maxSize: 500,
                    edge: .top,
                    persistKey: "viewHeight"
                ) {    
                
                ScrollView(.vertical) {
                    EditorRepresentable(text: $userPrompt)
                        .frame(minHeight: minInputHeight, maxHeight: .infinity)

                }
                .frame(minHeight: conv.editorHeight, maxHeight: conv.editorHeight)
                .padding(.top, inputHeightControlSize)
                .padding(.horizontal, Styles.paddingText)
                .scrollContentBackground(.hidden)
                .onChange(of: conv.isResponseLoading) {
                    isFocused = !conv.isResponseLoading
//                    editorHeight = nil
                }
                .background(.thinMaterial)

                
                
                
                } // END resizable
                
            } // END user text field hstack
            .overlay(alignment: .bottom) {
                HStack(spacing: 16) {
                    Spacer()
                    Toggle(isOn: $isTesting, label: {
                        Text("Test mode")
                    })
                    .foregroundStyle(isTesting ? .secondary : .quaternary)
                    .disabled(conv.isResponseLoading)
                    .toggleStyle(.switch)
                    .controlSize(.mini)
                    .tint(.secondary)
                    .animation(Styles.animationQuick, value: isTesting)
                    
                    Button(conv.isResponseLoading ? "Loading…" : "Send") {
                        
                        //                                        testScroll()
                        Task {
                            conv.isResponseLoading = true
                            await sendMessage(for: conversation)
                            conv.isResponseLoading = false
                            
                        }
                    }
                    .disabled(userPrompt.isEmpty)
                    .keyboardShortcut(.return, modifiers: .command)
                }
                .padding(.horizontal, Styles.paddingText)
                .padding(.top, 12)
                .padding(.bottom, 14)
                .background(.ultraThinMaterial)
//                .grainOverlay(opacity: 0.4)
            }
            
            
            
            
            .onAppear {
                if isPreview {
//                    userPrompt = ExampleText.basicMarkdown
//                    editorHeight = 600
                }
            }
            
            
            
        }
        
    }
    
    
    private func sendMessage(for conversation: Conversation) async {
        
        /// Save user message, so we can clear the input field
        let messageContents = userPrompt
        userPrompt = ""
        
        /// Create new `Message` object and add to database
        let newUserMessage = conv.createMessage(messageContents, with: .user, for: conversation)
        modelContext.insert(newUserMessage)
        
        /// Construct the message history for GPT context
        await conv.createMessageHistory(for: conversation, latestMessage: newUserMessage)
        
        do {
            let response: Message = try await conv.fetchGPTResponse(for: conversation, isTesting: isTesting)
            
            modelContext.insert(response)
            print(response.content)
            
            
        } catch {
            print("Error getting GPT response")
        }
        
    }
    
    
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        
        VStack {
            Spacer()
            ConversationView(conversation: Conversation.childcare)
        }
    }
    .environment(ConversationHandler())
    .environment(BanksiaHandler())
    .environmentObject(Preferences())
    .frame(width: 380, height: 700)
    .background(.contentBackground)
}
