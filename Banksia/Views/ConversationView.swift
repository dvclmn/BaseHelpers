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
import MarkdownEditor
import KeychainHandler
import Popup

struct ConversationView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var conv: ConversationHandler
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Bindable var conversation: Conversation
    
    @State private var userPrompt: String = ""
    
    @State private var testStream: String = "Let's stream"
    
    var body: some View {
        
        VStack {
            if let conversationMessages = conversation.messages {
                
                var searchResults: [Message] {
                    conversationMessages
                        .filter { message in
                        if conv.searchText.count > 1 {
                            return message.content.localizedCaseInsensitiveContains(conv.searchText)
                        } else {
                            return true
                        }
                    }
                        .sorted(by: { $0.timestamp < $1.timestamp })
                }
                
                VStack {
                    if conversationMessages.count > 0 {
                        if searchResults.count > 0 {
                            
                            // MARK: - Scrollview
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 12) {
                                    ForEach(searchResults, id: \.persistentModelID) { message in
                                        
                                        SingleMessageView(
                                            message: message
                                        )
                                        
                                    } // END ForEach
                                } // END lazy vstack
                                .padding(.vertical, 40)
                                .scrollTargetLayout()
                            } // END scrollview
                            .safeAreaPadding(.top, Styles.toolbarHeight)
                            .safeAreaPadding(.bottom, conv.editorHeight)
                            .defaultScrollAnchor(.bottom)
//                            .scrollPosition(id: $conv.scrolledMessageID, anchor: .bottom)
                            
//                            .overlay(alignment: .bottomTrailing) {
//                                Button {
//                                    conv.scrolledMessageID = searchResults.last?.id
//                                } label: {
//                                    Label("Scroll to latest message", systemImage: Icons.down.icon)
//                                }
//                                .buttonStyle(.customButton(size: .small, labelDisplay: .iconOnly))
//                                .padding(.bottom, conv.editorHeight + Styles.paddingSmall)
//                                .padding(.trailing, Styles.paddingSmall)
//                            } // END scroll to bottom
                            
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
                    VStack {
                        Text(testStream)
                        MessageInputView(
                            conversation: conversation,
                            userPrompt: $userPrompt
                        )
                    }
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
        //        .task(id: conv.streamingGPTMessageID) {
        //            if let id = conv.streamingGPTMessageID {
        //                print("conv.streamingGPTMessageID successfully updated to: \(id)")
        //                updateGPTResponseWithStream()
        //            }
        //        }
        
        //        .task(id: conv.streamedResponse) {
        //            updateGPTResponseWithStream()
        //        }
        .task(id: conv.scrolledMessageID) {
            if let message = conversation.messages?.first(where: {$0.persistentModelID == conv.scrolledMessageID}) {
                conv.scrolledMessagePreview = message.content.prefix(20).description
            }
        }
        .task(id: conv.currentRequest) {
            switch conv.currentRequest {
            case .sendQuery:
                await sendMessage()
                print("Send message requested")
                conv.currentRequest = .none
            default:
                break
            }
        }
        
        
    } // END view body
    
}

extension ConversationView {
    
    private func sendMessage() async {
        
        print("\n\n|--- Send message \(bk.isTestMode ? "Test mode" : "") --->\n")
        
        guard !userPrompt.isEmpty else {
            print("No query to send")
            return
        }
        print("There *is* a query to send")
        
        
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
        
        let newGPTMessage = Message(
            content: "",
            type: .assistant,
            conversation: conversation
        )
        
        modelContext.insert(newGPTMessage)
        
        // MARK: - Test mode
        guard !bk.isTestMode else {
            
            guard let lastMessage = conversation.messages?.last(where: { $0.type == .assistant }) else { return }
            
            lastMessage.content = ExampleText.paragraphs.randomElement() ?? "Couldn't randomise"
            
            conv.isResponseLoading = false
            
            return
        }
        
        // MARK: - Live mode
        do {
            
//            let requestBody = RequestBody(
//                model: bk.gptModel.model,
//                messages: messageHistory,
//                stream: true,
//                temperature: bk.gptTemperature
//            )
//            
//            let url = URL(string: OpenAIHandler.chatURL)!
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = try JSONEncoder().encode(requestBody)
//            request.allHTTPHeaderFields = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(apiKey)"
//            ]
            
            

            
            let question = "Hi, this is a test. Juts a brief response to see if this is working is fine."
            
            guard let request = try makeRequest(content: question) else {
                print("Could not make the request")
                return
            }
            
            let (stream, _) = try await URLSession.shared.bytes(for: request)
            
//            print("Stream: \(stream)")
            
            for try await line in stream.lines {
                print("Entered the stream. \(line)")
                
                guard let messageChunk = parse(line) else {
                print("Couldn't parse?")
                    continue
                }
                
//                guard let lastMessage = conversation.messages?.last(where: { $0.type == .assistant }) else {
//                    print("Issue with getting the last message")
//                    return
//                }
                
                testStream += messageChunk

            }
            
        } catch {
            print("Error getting GPT response")
        }
        conv.isResponseLoading = false
    } // END send message
    
    
    func makeRequest(content: String) throws -> URLRequest? {
        
        guard let apiKey = KeychainHandler.shared.readString(for: "openAIAPIKey") else {
            popup.showPopup(title: "No API Key found", message: "Please visit app Settings (⌘,) to set up your API Key")
            return nil
        }
        
        let query = RequestBody(
            model: bk.gptModel.model,
            messages: [.init(role: "user", content: content)],
            stream: true,
            temperature: bk.gptTemperature
        )
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(query)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        return request
    }
    
    func parse(_ line: String) -> String? {
        print("\n\n|--- Parse streamed response --->\n")
        print("Received line: \(line)")
        
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        
        guard components.count == 2, components[0] == "data" else {
            print("Component count was not equal to 2, or the first item in component array was not 'data'")
            return nil
        }
        
        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Decode into Chunk object
            let chunk = try? JSONDecoder().decode(GPTStreamedResponse.self, from: message.data(using: .utf8)!)

            if let finishReason = chunk?.choices.first?.finish_reason, finishReason == "stop" {
                return "\n"
            } else {
                return chunk?.choices.first?.delta.content
            }
    } // Stream parsing
    
}

//Couldn't parse?
//Entered the stream. data: {
//    "id":"chatcmpl-9VOQ1TfgUDaHLZo1Lav6B7EZz67Hu",
//    "object":"chat.completion.chunk",
//    "created":1717269061,
//    "model":"gpt-4o-2024-05-13",
//    "system_fingerprint":"fp_319be4768e",
//    "choices":[{"index":0,"delta":{"content":" messages"},"logprobs":null,"finish_reason":null}]
//}
//Couldn't parse?
//Entered the stream. data: {
//    "id":"chatcmpl-9VOQ1TfgUDaHLZo1Lav6B7EZz67Hu",
//    "object":"chat.completion.chunk",
//    "created":1717269061,
//    "model":"gpt-4o-2024-05-13",
//    "system_fingerprint":"fp_319be4768e",
//    "choices":[{"index":0,"delta":{"content":" in"},"logprobs":null,"finish_reason":null}]
//}
//Couldn't parse?
//Entered the stream. data: {
//    "id":"chatcmpl-9VOQ1TfgUDaHLZo1Lav6B7EZz67Hu",
//    "object":"chat.completion.chunk",
//    "created":1717269061,
//    "model":"gpt-4o-2024-05-13",
//    "system_fingerprint":"fp_319be4768e",
//    "choices":[{"index":0,"delta":{"content":" your"},"logprobs":null,"finish_reason":null}]
//}
//Couldn't parse?

