//
//  MessageInputView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
import GeneralStyles
import Sidebar
import GeneralUtilities
import Modifiers
import Swatches
import Resizable
import Icons
import APIHandler
import KeychainHandler
import Popup
import ScrollMask
import MarkdownEditor
import CountdownTimer
import Button

struct MessageInputView: View {
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var bk: BanksiaHandler
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Environment(\.modelContext) private var modelContext
    
    @SceneStorage("userPrompt") var userPrompt: String = ""
    
    @State private var isUIFaded: Bool = false
    
    @FocusState private var isFocused
    
    @State private var isHoveringHeightAdjustor: Bool = false
    @State private var isHoveringControls: Bool = false
    
    @State private var isMasked: Bool = true
    @State private var isScrolling: Bool = false
    
    @State private var countdown = CountdownTimer()

    
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        @Bindable var conv = conv
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                
                ScrollView(.vertical) {
                    
                    VStack {
                        
                        MarkdownEditorView(
                            text: $userPrompt,
                            placeholderText: "Begin writing here…",
                            isFocused: $isFocused
                        )
                        .safeAreaPadding(.top, 26)
                        .safeAreaPadding(.bottom, 90)
                        .padding(.horizontal, Styles.paddingText)
                        .focused($isFocused)
                        .onAppear {
                            isFocused = true
                        }
                    }
                    .onScrollThreshold(
                        threshold: 10,
                        isScrolling: $isScrolling
                    ) { thresholdReached in
                        
                        withAnimation(Styles.animation) {
                            isMasked = thresholdReached
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                
                
                .resizable(startingHeight: $bk.editorHeight, maxHeight: sidebar.windowSize.height * 0.8) { onChangeHeight, onEndHeight in
                    conv.editorHeight = onChangeHeight
                    bk.editorHeight = onEndHeight
                }
                .onTapGesture {
                    isFocused = true
                }
                .scrollMask(isMasked)
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .onChange(of: conv.isResponseLoading) {
                    isFocused = !conv.isResponseLoading
                }
                
                .task(id: isScrolling) {
                    startTimer()
                }
                
                .task(id: userPrompt) {
                    startTimer()
                }
                .task {
                    countdown.onCountdownEnd = {
                        withAnimation(Styles.animationEased) {
                            self.isUIFaded = false
                        }
                    }
                }
                .task(id: isFocused) {
                    conv.isEditorFocused = isFocused
                }
                
                .background(.thinMaterial)
                
                
                
                
            } // END user text field hstack
            
            // MARK: - Text area Buttons
            .overlay(alignment: .bottom) {
                
                Button {
                    
                } label: {
                    Label("Add to Message", systemImage: Icons.plus.icon)
                }
                .offset(y: -30)
                
                EditorControls()
                //
                    .onContinuousHover { phase in
                        switch phase {
                        case .active(_):
                            isHoveringControls = true
                        case .ended:
                            isHoveringControls = false
                        }
                    }
            } // END input buttons overlay
            
            .onAppear {
                //                userPrompt = ExampleText.paragraphs[3]
                conv.editorHeight = bk.editorHeight
            }
            
            
        }
        
    }
}

extension MessageInputView {
    

    private func startTimer() {
        if isFocused {
            countdown.startCountdown(for: 2)
            withAnimation(Styles.animationEasedSlow) {
                self.isUIFaded = true
            }
        }
    }
    
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
                
                conv.streamedResponse += messageChunk
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
    
    
    
    
}

extension MessageInputView {
    @ViewBuilder
    func EditorControls() -> some View {
        HStack(spacing: 10) {
            
            
            HStack(spacing: 18) {
                
                Label(bk.gptModel.name, systemImage: Icons.shocked.icon)
                Label("\(conv.totalTokens(for: conversation))", systemImage: Icons.token.icon)
                
                
            }
            .labelStyle(.customLabel(size: .mini))
            .padding(.leading, Styles.paddingNSTextViewCompensation)
            .symbolVariant(.fill)
            
            Spacer()
            
            Toggle(isOn: $bk.isTestMode, label: {
                Text("Test mode")
            })
            .foregroundStyle(bk.isTestMode ? .secondary : .quaternary)
            .disabled(conv.isResponseLoading)
            .toggleStyle(.switch)
            .controlSize(.mini)
            .tint(.secondary)
            .animation(Styles.animationQuick, value: bk.isTestMode)
            
            
            
            Button {
                Task {
                    
                    if bk.isTestMode {
                        await sendTestMessage()
                    } else {
                        await sendMessage()
                    }
                }
            } label: {
                Label(conv.isResponseLoading ? "Loading…" : "Send", systemImage: Icons.text.icon)
            }
            .buttonStyle(.customButton(size: .small, status: userPrompt.isEmpty ? .disabled : .normal, labelDisplay: .titleOnly))
            .disabled(userPrompt.isEmpty)
            .keyboardShortcut(.return, modifiers: .command)
            
        }
        .opacity(isUIFaded ? 0.2 : 1.0)
        .padding(.horizontal, Styles.paddingGutter)
        .padding(.bottom, Styles.paddingGutter)
    }
}

#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        
        VStack {
            Spacer()
            ConversationView(
                conversation: Conversation.childcare,
                scrolledMessageID: .constant(Message.prompt_01.persistentModelID)
            )
        }
    }
    .environment(ConversationHandler())
    .environmentObject(BanksiaHandler())
    
    .environmentObject(SidebarHandler())
    .frame(width: 380, height: 700)
    .background(.contentBackground)
}
#endif
