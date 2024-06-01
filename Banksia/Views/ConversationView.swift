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
import StateView
import Sidebar

struct ConversationView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Bindable var conversation: Conversation
    @Binding var scrolledMessageID: Message.ID?
    
    var body: some View {
        
        @Bindable var conv = conv
        
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
                                VStack(spacing: 12) {
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
                            StateView(title: "No matching results", message: "No results found for \"\(conv.searchText)\".")
                        }
                        
                    } else {
                        StateView(title: "No messages yet")
                            .padding(.top, Styles.toolbarHeight / 2)
                            .padding(.bottom, conv.editorHeight)
                        
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
                
                
                
            } else {
                
                Text("No messages here?")
                
            }// END has messages check
            
            
        } // END Vstack
        .task(id: conversation.grainientSeed) {
            withAnimation(Styles.animationRelaxed) {
                conv.grainientSeed = conversation.grainientSeed
            }
        }
        .task(id: conv.streamingGPTMessageID) {
            if let id = conv.streamingGPTMessageID {
                print("conv.streamingGPTMessageID successfully updated to: \(id)")
                updateGPTResponseWithStream()
            }
        }
        
        .task(id: conv.streamedResponse) {
            updateGPTResponseWithStream()
            
        }
        
        
        
        
    } // END view body
    
}

extension ConversationView {
    
    
    private func sendTestMessage() async {
        
        let newUserMessage = Message(
            content: userPrompt,
            type: .user,
            conversation: conversation
        )
        modelContext.insert(newUserMessage)
        
        userPrompt = ""
        conv.editorHeight = ConversationHandler.defaultEditorHeight
        
        /// Construct the message history for GPT context
        let messageHistory: [RequestMessage] = await conv.createMessageHistory(
            for: conversation,
            latestMessage: newUserMessage,
            with: bk.systemPrompt
        )
        
        print("Test-message history: \(messageHistory.prettyPrinted)")
        
        
        let newGPTMessage = Message(
            content: ExampleText.paragraphs.randomElement() ?? "No random element",
            type: .assistant,
            conversation: conversation
        )
        modelContext.insert(newGPTMessage)
        
        conv.isResponseLoading = false
        
    }
    
    private func sendMessage(_ isTestMode: Bool = false) async {
        
        guard let apiKey = KeychainHandler.shared.readString(for: "openAIAPIKey") else {
            popup.showPopup(title: "No API Key found", message: "Please visit app Settings (⌘,) to set up your API Key")
            return
        }
        
        conv.isResponseLoading = true
        
        
        /// Create new `Message` object and add to database
        let newUserMessage = Message(
            content: userPrompt,
            type: .user,
            conversation: conversation
        )
        modelContext.insert(newUserMessage)
        
        userPrompt = ""
        conv.editorHeight = ConversationHandler.defaultEditorHeight
        
        
        /// Construct the message history for GPT context
        let messageHistory: [RequestMessage] = await conv.createMessageHistory(
            for: conversation,
            latestMessage: newUserMessage,
            with: bk.systemPrompt
        )
        
        do {
            
            let newGPTMessage = Message(
                content: "",
                type: .assistant,
                conversation: conversation
            )
            
            modelContext.insert(newGPTMessage)
            
            

            let requestBody = RequestBody(
                model: bk.gptModel.model,
                messages: messageHistory,
                stream: true,
                temperature: bk.gptTemperature
            )
            
            
            let url = URL(string: OpenAIHandler.chatURL)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(requestBody)
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
            
            
            let (stream, _) = try await URLSession.shared.bytes(for: request)
            
            print("Stream: \(stream)")
            
            for try await line in stream.lines {
                print("Entered the stream. \(line)")
                guard let messageChunk = ConversationHandler.parse(line) else { continue }
                
                
                guard let lastMessage = conversation.messages?.last(where: { $0.type == .assistant }) else { return }
                lastMessage.content += messageChunk
                
                
                
            }
            
            //            let response: GPTResponse = try await APIHandler.constructRequestAndFetch(
            //                url: URL(string: OpenAIHandler.chatURL),
            //                requestType: .post,
            //                bearerToken: apiKey,
            //                body: requestBodyData
            //            )
            //
            //            guard let gptMessage = response.choices.first?.message.content else {
            //                print("No message content from GPT")
            //                return
            //            }
            
            
        } catch {
            print("Error getting GPT response")
        }
        
        conv.isResponseLoading = false
    } // END send message
    
    
    
    func updateLastAssistantMessage(with content: String) {
        guard let lastMessage = conversation.messages?.last(where: { $0.type == .assistant }) else { return }
        lastMessage.content += content
    }
    
    func updateGPTResponseWithStream() {
        
        
        
        //        print("\n\n|--- Update GPT message with Stream --->\n")
        //        if let conversation = conv.fetchCurrentConversationStatic(withID: nav.currentDestination, from: conversations) {
        //
        //            print("We got the current convoersation!: \(conversation)")
        //
        //            if let gptMessage = conversation.messages?.first(where: {$0.persistentModelID == conv.streamingGPTMessageID}) {
        //
        //                gptMessage.content += conv.streamedResponse
        //            } else {
        //                print("Could not get the current target GPT message")
        //            }
        //        } else {
        //            print("Could not get current conversation")
        //        }
    }
    
    
}


