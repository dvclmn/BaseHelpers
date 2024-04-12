//
//  MessageInputView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData

struct MessageInputView: View {
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var pref: Preferences
    @Environment(\.modelContext) private var modelContext
    
    @State private var prompt: String = "_Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*"
    
    var conversation: Conversation
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Rectangle()
                .fill(.blue.opacity(0.0))
                .offset(y: 5)
                .frame(height: 10)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0) // React to drag gestures with no minimum distance
                        .onChanged { gesture in
                            // Adjust the editorHeight based on the drag amount
                            pref.editorHeight += gesture.translation.height * -1
                            
                            // Optionally, enforce minimum and maximum height constraints
                            pref.editorHeight = min(max(pref.editorHeight, 100), 600) // Example min/max height
                        }
                )
                .cursor(.resizeUpDown)

            
            HStack(alignment: .bottom) {

                EditorTextViewRepresentable(text: $prompt)
                    .frame(height: pref.editorHeight)
                
                Button(bk.isResponseLoading ? "Loading…" : "Send") {
                    
                    testScroll(conversation: conversation)
                    
                    //                    Task {
                    //                        await sendMessage(userMessage: prompt)
                    //                    }
                }
                .disabled(prompt.isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
                .padding()
            } // END user text field hstack
            
            .background(.black.opacity(0.4))
//            .onAppear {
//                //            self.prompt = Message.prompt_02.content
//                self.prompt = bigText
//            }
            
            
            
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
        
        VStack {
            Spacer()
            MessageInputView(conversation: Conversation.appKitDrawing)
        }
    }
    .environment(BanksiaHandler())
    .environmentObject(Preferences())
    .frame(width: 560, height: 700)
}
