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
import Grainient

struct ConversationView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        @Bindable var conv = conv
        
        VStack {
            if let messages = conversation.messages {
                
                var searchResults: [Message] {
                    messages
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
                    if messages.count > 0 {
                        if searchResults.count > 0 {
                            
                            // MARK: - Scrollview
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 12) {
                                    ForEach(searchResults, id: \.persistentModelID) { message in
                                        
                                        SingleMessageView(
                                            conversation: conversation,
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
                            .scrollPosition(id: $conv.scrolledMessageID, anchor: .bottom)
                            
                            .overlay(alignment: .bottomTrailing) {
                                Button {
                                    conv.scrolledMessageID = searchResults.last?.id
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
                
                .overlay(alignment: .bottom) {
                    VStack {
                        MessageInputView(
                            conversation: conversation
                        )
                    }
                }
                .sheet(isPresented: $conv.isConversationEditorShowing) {
                    ConversationSettingsView(conversation: conversation)
                }
            } else {
                
                Text("No messages here?")
                
            }// END has messages check
            
        } // END Vstack
        //        .task(id: conversation.grainientSeed) {
        //            withAnimation(Styles.animationRelaxed) {
        //                conv.grainientSeed = conversation.grainientSeed
        //            }
        //        }

        .task(id: conv.currentRequest) {
            switch conv.currentRequest {
            case .sendQuery:
                await sendMessage()
                print("Send message requested")
                conv.currentRequest = .none
                
            case .generateConversationGrainient:
                withAnimation(Styles.animationRelaxed) {
                    conversation.grainientSeed = GrainientSettings.generateGradientSeed()
                }
                conv.currentRequest = .none
            default:
                break
            }
        }
        .task {
            //            if bk.isTestMode {
            conv.userPrompt = ExampleText.conversationTitles.randomElement() ?? "No random"
            //            }
        }
        
        
        
    } // END view body
    
}

extension ConversationView {
    
    private func sendMessage() async {
        
        print("\n\n|--- Send message \(bk.isTestMode ? "Test mode" : "") --->\n")
        
        guard !conv.userPrompt.isEmpty else {
            print("No query to send")
            return
        }
        print("There *is* a query to send")
        
        conv.isResponseLoading = true
        
        /// Create new `Message` object and add to database
        let newUserMessage = Message(
            content: conv.userPrompt,
            type: .user
        )
        modelContext.insert(newUserMessage)
        
        newUserMessage.conversation = conversation
        
        conv.userPrompt = ""
        conv.editorHeight = ConversationHandler.defaultEditorHeight
        
        
        /// Construct the message history for GPT context
        let messageHistory: [RequestMessage] = await conv.createMessageHistory(
            for: conversation,
            latestMessage: newUserMessage,
            with: bk.systemPrompt
        )
        
        print("Message history:\n\n\(messageHistory.prettyPrinted)")
        
        let newGPTMessage = Message(
            content: "",
            type: .assistant
        )
        modelContext.insert(newGPTMessage)
        
        newGPTMessage.conversation = conversation
        
        // MARK: - Test mode
        guard !bk.isTestMode else {
            
            //            func updateMessageContent(message: Message) async {
            //                let streamer = DataStreamer()
            //
            //                do {
            //                    for try await chunk in streamer {
            //                        await MainActor.run {
            //                            newGPTMessage.content += chunk
            //                            conv.streamedResponse += chunk
            //                        }
            //                    }
            //                } catch {
            //                    print("There was a problem in Single Message view")
            //                }
            //            }
            
            conv.isResponseLoading = false
            
            return
        }
        
        // MARK: - Live mode
        do {
            
            guard let request = try makeRequest(content: messageHistory) else {
                print("Could not make the request")
                return
            }
            
            /// Credit to https://gist.github.com/arthurgarzajr/89a485a50af30ef4183e725a43bba230
            /// and https://zachwaugh.com/posts/streaming-messages-chatgpt-swift-asyncsequence
            /// for helping me figure out streaming
            let (stream, _) = try await URLSession.shared.bytes(for: request)
            
            for try await line in stream.lines {
                
                guard let messageChunk = parse(line) else {
                    print("Couldn't parse?")
                    continue
                }
                newGPTMessage.content += messageChunk
            }
            
        } catch {
            print("Error getting GPT response")
        }
        conv.isResponseLoading = false
    } // END send message
    
    
    func makeRequest(content: [RequestMessage]) throws -> URLRequest? {
        
        guard let apiKey = KeychainHandler.shared.readString(for: "openAIAPIKey") else {
            popup.showPopup(title: "No API Key found", message: "Please visit app Settings (⌘,) to set up your API Key")
            return nil
        }
        
        let query = RequestBody(
            model: bk.gptModel.model,
            messages: content,
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
        //        print("Received line: \(line)")
        
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
