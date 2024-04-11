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
import SwiftDown
import EditorCore
import EditorUI


struct MessageInputView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
//    let highlightr = Highlightr()
    
    @State private var prompt: String = ""
//    @State private var theme    = CodeEditor.ThemeName.pojoaque
    
    var conversation: Conversation
    
    var body: some View {
        
        
//        EditorTextViewRepresentable(text: $prompt)
        
        
        
        HStack(alignment: .bottom) {
            
//            Picker("Theme", selection: $theme) {
//                ForEach(CodeEditor.availableThemes) { theme in
//                    Text("\(theme.rawValue.capitalized)")
//                        .tag(theme)
//                }
//            }
////            .pickerStyle(.radioGroup)
//            
//            CodeEditor(
//                source: $prompt,
//                language: .markdown,
//                theme: theme
//            )
//            .background(.clear)
//            .scrollContentBackground(.hidden)
            
            
            SwiftDownEditor(text: $prompt)

            
            
            //            TextEditor(text: $prompt)
            //                .fixedSize(horizontal: false, vertical: true)
            //                .frame(minHeight: 80, alignment: .top)
            //                .padding(.trailing)
            //                .font(.system(size: 14))
            //                .scrollContentBackground(.hidden)
            //                RichTextView(text: $prompt)
            //                    .frame(minHeight: 200, maxHeight: 400)
            
            
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
            self.prompt = Message.prompt_02.content
            
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
