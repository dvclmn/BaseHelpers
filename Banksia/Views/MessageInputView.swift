//
//  MessageInputView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
import Styles
import GeneralUtilities
import Modifiers
import Swatches
import Resizable
import Icons
import APIHandler
import KeychainHandler
import Popup

struct MessageInputView: View {
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    
    @Environment(\.modelContext) private var modelContext
    
    @SceneStorage("userPrompt") var userPrompt: String = ""
    
    @SceneStorage("isTesting") var isTesting: Bool = true
    
    @State private var isHoveringHeightAdjustor: Bool = false
    
    let minInputHeight: Double = 100
    let maxInputHeight: Double = 580
    
    let inputHeightControlSize: Double = 12
    
    @FocusState private var isFocused
    
    var conversation: Conversation
    
    var body: some View {
        
        @Bindable var conv = conv
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                
                ScrollView(.vertical) {
                    EditorRepresentable(text: $userPrompt)
                        .frame(minHeight: minInputHeight, maxHeight: .infinity)
                    
                }
                .frame(minHeight: conv.editorHeight, maxHeight: conv.editorHeight)
                .padding(.top, inputHeightControlSize)
                .padding(.horizontal, Styles.paddingText)
                .scrollContentBackground(.hidden)
                .onChange(of: conv.isResponseLoading) {
                    isFocused = !conv.isResponseLoading
                }
                .background(.thinMaterial)
                .resizable(height: $conv.editorHeight)
                
                
            } // END user text field hstack
            .overlay(alignment: .bottom) {
                HStack(spacing: 16) {
                    Spacer()
                    
                    TestToggle()
                    
                    Button {
                        Task {
                            await sendMessage()
                        }
                    } label: {
                        Label(conv.isResponseLoading ? "Loading…" : "Send", systemImage: Icons.text.icon)
                    }
                    .buttonStyle(.customButton(status: userPrompt.isEmpty ? .disabled : .normal, labelDisplay: .titleOnly))
                    .disabled(userPrompt.isEmpty)
                    .keyboardShortcut(.return, modifiers: .command)
                    
                    
                }
                .padding(.horizontal, Styles.toolbarSpacing)
                .padding(.top, 12)
                .padding(.bottom, 14)
            }
            .task(id: conv.editorHeight) {
                pref.editorHeight = conv.editorHeight
            }
            .onAppear {
                if let editorHeightPreference = pref.editorHeight {
                    conv.editorHeight = editorHeightPreference
                }
            }
            
        }
        
    }
}

extension MessageInputView {
    
    @ViewBuilder
    func TestToggle() -> some View {
        Toggle(isOn: $isTesting, label: {
            Text("Test mode")
        })
        .foregroundStyle(isTesting ? .secondary : .quaternary)
        .disabled(conv.isResponseLoading)
        .toggleStyle(.switch)
        .controlSize(.mini)
        .tint(.secondary)
        .animation(Styles.animationQuick, value: isTesting)
    } // END test toggle
    
    private func sendMessage() async {
        
        
        
        guard let apiKey = KeychainHandler.shared.readString(for: "openAIAPIKey") else {
            popup.showPopup(title: "No API Key found", message: "Please visit app Settings (⌘,) to set up your API Key")
            return
        }
        
        conv.isResponseLoading = true
        
        /// Save user message, so we can clear the input field
        let messageContents = userPrompt
        userPrompt = ""
        
        
        
        /// Create new `Message` object and add to database
        let newUserMessage = Message(
            content: messageContents,
            type: .user,
            conversation: conversation
        )
        modelContext.insert(newUserMessage)
        
        /// Construct the message history for GPT context
        await conv.createMessageHistory(for: conversation, latestMessage: newUserMessage)
        
        do {
            
            let requestBody = RequestBody(
                model: pref.gptModel.value,
                messages: [
                    RequestMessage(role: "system", content: pref.systemPrompt),
                    RequestMessage(role: "user", content: messageContents)
                ],
                stream: true,
                temperature: pref.gptTemperature
            )
            
            let requestBodyData = APIHandler.encodeBody(requestBody)
            
            let request = try APIHandler.makeURLRequest(
                from: URL(string: OpenAI.chatURL),
                requestType: .post,
                bearerToken: apiKey,
                body: requestBodyData
            )
            
            let newGPTMessage = Message(
                content: "",
                type: .assistant,
                conversation: conversation
            )
            modelContext.insert(newGPTMessage)
            
            let (stream, _) = try await URLSession.shared.bytes(for: request)
            
            for try await line in stream.lines {
                guard let messageChunk = parse(line) else { continue }
                
                newGPTMessage.content += messageChunk
            }
            
            /// Parse a line from the stream and extract the message
            func parse(_ line: String) -> String? {
                let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
                guard components.count == 2, components[0] == "data" else { return nil }
                
                let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                if message == "[DONE]" {
                    return "\n"
                } else {
                    let chunk = try? JSONDecoder().decode(GPTResponse.self, from: message.data(using: .utf8)!)
                    return chunk?.choices.first?.message.content
                }
            }
            
            
        } catch {
            print("Error getting GPT response")
        }
        
        conv.isResponseLoading = false
    } // END send message
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        
        VStack {
            Spacer()
            ConversationView(conversation: Conversation.childcare)
        }
    }
    .environment(ConversationHandler())
    .environment(BanksiaHandler())
    .environmentObject(Preferences())
    .frame(width: 380, height: 700)
    .background(.contentBackground)
}
