//
//  MessageInputView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData

struct MessageInputView: View {
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var pref: Preferences
    @Environment(\.modelContext) private var modelContext
    
    @SceneStorage("userPrompt") var userPrompt: String = ""
    @SceneStorage("editorHeight") var editorHeight: Double = 300
    
    @FocusState private var isFocused
    
    var conversation: Conversation
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(alignment: .bottom, spacing: 0) {
                
                TextEditor(text: $userPrompt)
                    .disabled(conv.isResponseLoading)
                    .focused($isFocused)
                    .font(.system(size: 15))
                    .padding()
                    .scrollContentBackground(.hidden)
                //                ScrollView(.vertical) {
                //                    EditorTextViewRepresentable(text: $prompt)
                //                }
                    .frame(height: editorHeight)

                    .onChange(of: conv.isResponseLoading) {
                        isFocused = !conv.isResponseLoading
                    }
                
                Button(conv.isResponseLoading ? "Loading…" : "Send") {
                    
                    //                                        testScroll()
                    Task {
                        await sendMessage(for: conversation)
                        
                    }
                }
                .disabled(userPrompt.isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
                .padding()
            } // END user text field hstack
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(.blue.opacity(0.0))
                    .frame(height: 10)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0) // React to drag gestures with no minimum distance
                            .onChanged { gesture in
                                // Adjust the editorHeight based on the drag amount
                                editorHeight += gesture.translation.height * -1
                                
                                // Optionally, enforce minimum and maximum height constraints
                                editorHeight = min(max(editorHeight, 100), 600) // Example min/max height
                            }
                    )
                    .cursor(.resizeUpDown)
                
            }
            
            .background(.black.opacity(0.4))
            
                //            self.prompt = Message.prompt_02.content
                //                            if isPreview {
                //                                pref.userPrompt = bigText
                //                            }
            
            
            
        }
        
    }
    
//    private func testScroll() {
//        let newMessage = Message(content: pref.userPrompt)
//        modelContext.insert(newMessage)
//        newMessage.conversation = conversation
//    }
    
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
            let response: Message = try await conv.fetchGPTResponse(for: conversation)
            
            modelContext.insert(response)
            
            
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
    .frame(width: 560, height: 700)
}
