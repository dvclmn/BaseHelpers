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
import KeychainSwift
import Popup
import Grainient

struct ConversationView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    let keychain = KeychainSwift()
    
    @EnvironmentObject var pref: Preferences
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
                                VStack(spacing: 12) {
                                    ForEach(searchResults, id: \.persistentModelID) { message in
                                        
                                        SingleMessageView(
                                            conversation: conversation,
                                            message: message
                                        )
                                        
                                    } // END ForEach
                                } // END lazy vstack
                                .padding(.top, 60)
                                .padding(.bottom, 200)
                                .scrollTargetLayout()
                            } // END scrollview
                            .safeAreaPadding(.top, Styles.toolbarHeight)
                            .safeAreaPadding(.bottom, conv.editorHeight)
                            .defaultScrollAnchor(.bottom)
//                            .scrollPosition(id: $conv.scrolledMessageID, anchor: .bottom)
                            
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
//            conv.userPrompt = ExampleText.conversationTitles.randomElement() ?? "No random"
            //            }
        }
        
        
        
    } // END view body
    
}

extension ConversationView {
    
    private func sendMessage() async {
        
        guard let apiKey = keychain.get("openAIAPIKey") else {
            popup.showPopup(title: "No API Key found", message: "Please visit app Settings (⌘,) to set up your API Key")
            return
        }
            
        
        print("\n\n|--- Send message \(pref.isTestMode ? "Test mode" : "") --->\n")
        
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
            with: pref.systemPrompt
        )
        
        
        
        let newGPTMessage = Message(
            content: "",
            type: .assistant
        )
        modelContext.insert(newGPTMessage)
        
        newGPTMessage.conversation = conversation
        
        // MARK: - Test mode
        guard !pref.isTestMode else {
            
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
            
            guard let request = try makeRequest(content: messageHistory, key: apiKey) else {
                print("Could not make the request")
                return
            }
            
            /// Credit to https://gist.github.com/arthurgarzajr/89a485a50af30ef4183e725a43bba230
            /// and https://zachwaugh.com/posts/streaming-messages-chatgpt-swift-asyncsequence
            /// for helping me figure out streaming
            let (stream, _) = try await URLSession.shared.bytes(for: request)
            
            var finalUsage: GPTUsage?
            
            for try await line in stream.lines {
                guard let (messageChunk, usage) = parse(line) else {
                    print("Couldn't parse?")
                    continue
                }
                
                if let content = messageChunk {
                    newGPTMessage.content += content
                }
                
                if let usageData = usage {
                    finalUsage = usageData
                }
            }
            
            if let usage = finalUsage {
                newGPTMessage.promptTokens = usage.prompt_tokens
                newGPTMessage.completionTokens = usage.completion_tokens
            }
            
//            newGPTMessage.promptTokens = stream
            
        } catch {
            print("Error getting GPT response")
        }
        conv.isResponseLoading = false
    } // END send message
    
    
    func makeRequest(content: [RequestMessage], key: String) throws -> URLRequest? {
        
        let query = RequestBody(
            model: pref.gptModel.model,
            messages: content,
            stream: true,
            stream_options: .init(include_usage: true),
            max_tokens: nil,
            temperature: pref.gptTemperature
        )
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(query)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(key)"
        ]
        return request
    }
    
    func parse(_ line: String) -> (String?, GPTUsage?)? {
        print("\n\n|--- Parse streamed response --->\n")
        
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        
        guard components.count == 2, components[0] == "data" else {
            print("Component count was not equal to 2, or the first item in component array was not 'data'")
            return (nil, nil)
        }
        
        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        if message == "[DONE]" {
          return ("\n", nil)
        } else {
          let chunk = try? JSONDecoder().decode(GPTChunk.self, from: message.data(using: .utf8)!)
            
            let content = chunk?.choices.first?.delta.content
                        let usage = chunk?.usage
                        return (content, usage)
            
            
//          return chunk?.choices.first?.delta.content
        }
        
//        // Decode into Chunk object
//        let chunk = try? JSONDecoder().decode(GPTChunk.self, from: message.data(using: .utf8)!)
        
        
//        if let finishReason = chunk?.choices.first?.finish_reason, finishReason == "stop" {
//            return "\n"
//        } else {
//            return chunk?.choices.first?.delta.content
//        }
    } // Stream parsing

    
}
