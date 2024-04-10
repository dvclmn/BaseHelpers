//
//  MessagesView.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import SwiftUI
import SwiftData

struct MessagesView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    @State private var prompt: String = ""
    
    var conversation: Conversation
    
    var body: some View {
        
        VStack {
            if let messages = conversation.messages {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 12) {
                            ForEach(messages.sorted(by: { $0.timestamp < $1.timestamp })) { message in
                                VStack(alignment: .leading) {
                                    Text(message.content)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(message.isUser ? .blue : .gray))
                                        .cornerRadius(10)
                                }
                                .id(message.id)
                            } // END ForEach
                        } // END lazy vstack
                        .padding()
                        .onChange(of: messages.count) {
                            if let latest = messages.last {
                                proxy.scrollTo(latest.id)
                            }
                        }
                    } // END scrollview
                    .onAppear {
                        if let latest = messages.last {
                            proxy.scrollTo(latest.id)
                        }
                    }
                    
                    
                } // END scrollviuew reader
            } else {
                Text("No messages yet")
            } // END messages check
            
            
            HStack(alignment: .bottom) {
                
                TextEditor(text: $prompt)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(minHeight: 80, alignment: .top)
                    .padding(.trailing)
                    .font(.system(size: 14))
                    .scrollContentBackground(.hidden)
                //                RichTextView(text: $prompt)
                //                    .frame(minHeight: 200, maxHeight: 400)
                
                
                Button(bk.isResponseLoading ? "Loading…" : "Send") {
                    Task {
                        await sendMessage(userMessage: prompt)
                    }
                }
                .disabled(prompt.isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
            } // END user text field hstack
            .padding()
            .background(.black.opacity(0.4))
        } // END Vstack
        .navigationTitle("\(conversation.name)")
        .onAppear {
            self.prompt = Message.prompt_02.content
            
        }
    }
    
    private func sendMessage(userMessage: String) async {
        // Trim the message to remove leading and trailing whitespaces and newlines
        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the trimmed message is empty and return early if it is
        guard !trimmedMessage.isEmpty else {
            print("Message is empty, nothing to send")
            return
        }
        
        // Create a Message object for the user's message and append it to the conversation
        let newUserMessage = Message(content: "Q: \(trimmedMessage)", isUser: true)

        modelContext.insert(newUserMessage)
        conversation.messages?.append(newUserMessage)
        
        
        do {
            
            let response: GPTReponse = try await bk.fetchGPTResponse(prompt: trimmedMessage)
            
            guard let firstMessage = response.choices.first else { return }
            
            let responseMessage = Message(content: "A: \(firstMessage.message)", isUser: false)
            modelContext.insert(responseMessage)
            conversation.messages?.append(responseMessage)
            
        } catch {
            print("Error getting GPT response ")
        }
        
    } // END send message
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationContentView()
            .environment(BanksiaHandler())
            .frame(width: 600, height: 700)
    }
}
