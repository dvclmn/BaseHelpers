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
    
    @State private var isTextHidden: Bool = false
    
    var conversation: Conversation
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            
            HStack(alignment: .bottom, spacing: 0) {
                
                TextEditor(text: $pref.userPrompt)
                    .disabled(isTextHidden)
                    .foregroundStyle(isTextHidden ? .cyan : .primary.opacity(0.8))
                    .font(.system(size: 15))
                    .padding()
                    .scrollContentBackground(.hidden)
                //                ScrollView(.vertical) {
                //                    EditorTextViewRepresentable(text: $prompt)
                //                }
                                    .frame(height: pref.editorHeight)
                //                    .onChange(of: prompt) {
                //                        pref.pref.userPrompt = prompt
                //                    }
                
                
                Button(bk.isResponseLoading ? "Loading…" : "Send") {
                    
                    //                                        testScroll()
                    Task {
                        await sendPromptToGPT(pref.userPrompt)
                        pref.userPrompt = ""
                    }
                }
                .disabled(pref.userPrompt.isEmpty)
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
                                pref.editorHeight += gesture.translation.height * -1
                                
                                // Optionally, enforce minimum and maximum height constraints
                                pref.editorHeight = min(max(pref.editorHeight, 100), 600) // Example min/max height
                            }
                    )
                    .cursor(.resizeUpDown)
                
            }
            
            .background(.black.opacity(0.4))
            //            .onAppear {
            //                //            self.prompt = Message.prompt_02.content
            //                self.prompt = bigText
            //            }
            
            
        }
        
    }
    
    private func testScroll() {
        let newMessage = Message(content: pref.userPrompt)
        modelContext.insert(newMessage)
        newMessage.conversation = conversation
    }
    

    private func sendPromptToGPT(_ prompt: String) async {
        
        self.isTextHidden = true
        
        let newUserMessage = Message(content: prompt, isUser: true)
        
        modelContext.insert(newUserMessage)
        newUserMessage.conversation = conversation

        
        do {
            
            let response: GPTReponse = try await bk.fetchGPTResponse(prompt: prompt)
            
            guard let firstMessage = response.choices.first else { return }
            
            let responseMessage = Message(content: firstMessage.message.content, isUser: false)
            modelContext.insert(responseMessage)
            conversation.messages?.append(responseMessage)
            
        } catch {
            print("Error getting GPT response ")
        }
        
        isTextHidden = false
        
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
