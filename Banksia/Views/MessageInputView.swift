//
//  MessageInputView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
//import CodeEditor
//import Highlightr
//import SwiftDown
//import EditorCore
import EditorUI


struct MessageInputView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    
    @State private var prompt: String = ""
    
    @State private var text: String = "Your initial text here"
    @State private var editorHeight: CGFloat = 300 // Initial height of the editor
    
    
    //    @State private var theme    = CodeEditor.ThemeName.pojoaque
    
    var conversation: Conversation
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            
            Rectangle()
                .fill(.blue)
                .frame(height: 6)
            
                .background(Color.gray.opacity(0.5)) // Visual feedback
                .gesture(
                    DragGesture(minimumDistance: 0) // React to drag gestures with no minimum distance
                        .onChanged { gesture in
                            // Adjust the editorHeight based on the drag amount
                            editorHeight += gesture.translation.height * -1
                            
                            // Optionally, enforce minimum and maximum height constraints
                            editorHeight = min(max(editorHeight, 100), 600) // Example min/max height
                        }
                )
            
            
            HStack(alignment: .bottom) {
                //            ScrollView(.vertical) {
                EditorTextViewRepresentable(text: $prompt)
                //            }
                    .frame(height: editorHeight)
                
                Button(bk.isResponseLoading ? "Loading…" : "Send") {
                    
                    testScroll(conversation: conversation)
                    
                    //                    Task {
                    //                        await sendMessage(userMessage: prompt)
                    //                    }
                }
                .disabled(prompt.isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
            } // END user text field hstack
            .padding()
            .background(.black.opacity(0.4))
            .onAppear {
                //            self.prompt = Message.prompt_02.content
                self.prompt = bigText
            }
            
            
            
        }
    }
    
    private func testScroll(conversation: Conversation) {
        let newMessage = Message(content: prompt)
        modelContext.insert(newMessage)
        newMessage.conversation = conversation
    }
    
    //    private func sendMessage(userMessage: String) async {
    //        // Trim the message to remove leading and trailing whitespaces and newlines
    //        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    //
    //        // Check if the trimmed message is empty and return early if it is
    //        guard !trimmedMessage.isEmpty else {
    //            print("Message is empty, nothing to send")
    //            return
    //        }
    //
    //        // Create a Message object for the user's message and append it to the conversation
    //        let newUserMessage = Message(content: "Q: \(trimmedMessage)", isUser: true)
    //
    //        modelContext.insert(newUserMessage)
    //        conversation.messages?.append(newUserMessage)
    //
    //
    //        do {
    //
    //            let response: GPTReponse = try await bk.fetchGPTResponse(prompt: trimmedMessage)
    //
    //            guard let firstMessage = response.choices.first else { return }
    //
    //            let responseMessage = Message(content: "A: \(firstMessage.message)", isUser: false)
    //            modelContext.insert(responseMessage)
    //            conversation.messages?.append(responseMessage)
    //
    //        } catch {
    //            print("Error getting GPT response ")
    //        }
    //
    //    } // END send message
    
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        MessageInputView(conversation: Conversation.appKitDrawing)
    }
    .environment(BanksiaHandler())
    .frame(width: 700, height: 700)
}
