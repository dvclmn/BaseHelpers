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
    
//    @State private var prompt: String = ""
    
    var conversation: Conversation
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            
            HStack(alignment: .bottom, spacing: 0) {
                
                TextEditor(text: $pref.userPrompt)
                    .font(.system(size: 15))
                    .padding()
                    .scrollContentBackground(.hidden)
                //                ScrollView(.vertical) {
                //                    EditorTextViewRepresentable(text: $prompt)
                //                }
//                    .frame(height: pref.editorHeight)
//                    .onChange(of: prompt) {
//                        pref.userPrompt = prompt
//                    }
                
                
                Button(bk.isResponseLoading ? "Loading…" : "Send") {
                    
                    //                    testScroll(conversation: conversation)
                    
                    Task {
                        await sendMessage(userMessage: pref.userPrompt)
                    }
                }
                .disabled(pref.userPrompt.isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
                .padding()
            } // END user text field hstack
            //            .overlay(alignment: .top) {
            //                Rectangle()
            //                    .fill(.blue.opacity(0.0))
            //                    .frame(height: 10)
            //                    .contentShape(Rectangle())
            //                    .gesture(
            //                        DragGesture(minimumDistance: 0) // React to drag gestures with no minimum distance
            //                            .onChanged { gesture in
            //                                // Adjust the editorHeight based on the drag amount
            //                                pref.editorHeight += gesture.translation.height * -1
            //
            //                                // Optionally, enforce minimum and maximum height constraints
            //                                pref.editorHeight = min(max(pref.editorHeight, 100), 600) // Example min/max height
            //                            }
            //                    )
            //                    .cursor(.resizeUpDown)
            //
            //            }
            
            .background(.black.opacity(0.4))
            //            .onAppear {
            //                //            self.prompt = Message.prompt_02.content
            //                self.prompt = bigText
            //            }
            
//                        .onAppear {
//                            if !pref.userPrompt.isEmpty {
//                                prompt = pref.userPrompt
//                            }
//                        }
//                        .onDisappear {
//                            if !prompt.isEmpty {
//                                pref.userPrompt = prompt
//                            }
//                        }
        }
        
    }
    
    //    private func testScroll(conversation: Conversation) {
    //        let newMessage = Message(content: prompt)
    //        modelContext.insert(newMessage)
    //        newMessage.conversation = conversation
    //    }
    //
    private func sendMessage(userMessage: String) async {
        
//        let exampleMessage: String = """
//
//Thanks! I am getting an error `Value of type '[NSRange : [NSLayoutManager.GlyphProperty]]' (aka 'Dictionary<_NSRange, Array<NSLayoutManager.GlyphProperty>>') has no member 'withUnsafeBufferPointer'` on line `fixedGlyphProperties.withUnsafeBufferPointer { bufferPointer in`
//
//Here is some of the preceeding code for context:
//
//```
//// Set the glyph properties
//        for i in 0 ..< glyphRange.length {
//            let characterIndex = charIndexes[i]
//            var glyphProperties = props[i]
//
//            let matchingHiddenRanges = hiddenRanges.filter { NSLocationInRange(characterIndex, $0) }
//            if !matchingHiddenRanges.isEmpty {
//                // Note: .null is the value that makes sense here, however it causes strange indentation issues when the first glyph on the line is hidden.
//                glyphProperties = .controlCharacter
//            }
//            
//            fixedGlyphProperties[glyphRange]!.append(glyphProperties)
//        }
//```
//"""
        // Trim the message to remove leading and trailing whitespaces and newlines
//        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the trimmed message is empty and return early if it is
        guard !userMessage.isEmpty else {
            print("Message is empty, nothing to send")
            return
        }
        
        // Create a Message object for the user's message and append it to the conversation
        let newUserMessage = Message(content: pref.userPrompt, isUser: true)
        
        modelContext.insert(newUserMessage)
        conversation.messages?.append(newUserMessage)
        pref.userPrompt = ""
        
        do {
            
            let response: GPTReponse = try await bk.fetchGPTResponse(prompt: pref.userPrompt)
            
            guard let firstMessage = response.choices.first else { return }
            
            let responseMessage = Message(content: firstMessage.message.content, isUser: false)
            modelContext.insert(responseMessage)
            conversation.messages?.append(responseMessage)
            
        } catch {
            print("Error getting GPT response ")
        }
        
    } // END send message
    
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        
        VStack {
            Spacer()
            ConversationView()
        }
    }
    .environment(BanksiaHandler())
    .environmentObject(Preferences())
    .frame(width: 560, height: 700)
}
