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
                .frame(minHeight: conv.editorHeight, maxHeight: conv.editorHeight)
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
                .resizable(
                    height: $conv.editorHeight,
                    maxHeight: sidebar.windowSize.height * 0.8
                )

                
                
                
            } // END user text field hstack
            
            // MARK: - Text area Buttons
            .overlay(alignment: .bottom) {
                EditorControls()
                    
                    .onContinuousHover { phase in
                        switch phase {
                        case .active(_):
                            isHoveringControls = true
                        case .ended:
                            isHoveringControls = false
                        }
                    }
            } // END input buttons overlay
            
            .task(id: conv.editorHeight) {
                bk.editorHeight = conv.editorHeight
            }
            .onAppear {
//                userPrompt = ExampleText.paragraphs[3]
                if let editorHeightPreference = bk.editorHeight {
                    conv.editorHeight = editorHeightPreference
                }
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
    
    private func sendMessage(_ isTestMode: Bool = false) async {
        
        guard let apiKey = KeychainHandler.shared.readString(for: "openAIAPIKey") else {
            popup.showPopup(title: "No API Key found", message: "Please visit app Settings (⌘,) to set up your API Key")
            return
        }
        
        conv.isResponseLoading = true
        
        /// Save user message, so we can clear the input field
        let messageContents = userPrompt
        print("User prompt was:\n\(messageContents)")
        userPrompt = ""
        conv.editorHeight = ConversationHandler.defaultEditorHeight
        
        
        /// Create new `Message` object and add to database
        let newUserMessage = Message(
            content: messageContents,
            type: .user,
            conversation: conversation
        )
        modelContext.insert(newUserMessage)
        
        /// Construct the message history for GPT context
        let messageHistory: String = await conv.createMessageHistory(for: conversation, latestMessage: newUserMessage)
        
        do {
            
            let requestBody = RequestBody(
                model: bk.gptModel.model,
                messages: [
                    RequestMessage(role: "system", content: bk.systemPrompt),
                    RequestMessage(role: "user", content: messageHistory)
                ],
                stream: false,
                temperature: bk.gptTemperature
            )
            
            let requestBodyData = APIHandler.encodeBody(requestBody)
            
            print("Body Encoded: \(String(describing: requestBodyData))")
            
            let response: GPTResponse = try await APIHandler.constructRequestAndFetch(
                url: URL(string: OpenAIHandler.chatURL),
                requestType: .post,
                bearerToken: apiKey,
                body: requestBodyData
            )
            
            guard let gptMessage = response.choices.first?.message.content else {
                print("No message content from GPT")
                return
            }
            
            let newGPTMessage = Message(
                content: gptMessage,
                promptTokens: response.usage.prompt_tokens,
                completionTokens: response.usage.completion_tokens,
                type: .assistant,
                conversation: conversation
            )
            modelContext.insert(newGPTMessage)
            
            //            let (stream, _) = try await URLSession.shared.bytes(for: request)
            //            print("Stream: \(stream)")
            //
            //            for try await line in stream.lines {
            //                print("Entered the stream. \(line)")
            //                guard let messageChunk = ConversationHandler.parse(line) else { continue }
            //
            //                newGPTMessage.content += messageChunk
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
            
            //                    TestToggle()
            
            //                    Button {
            //                        Task {
            //                            userPrompt = conv.getRandomParagraph()
            //                            await sendMessage()
            //                        }
            //                    } label: {
            //                        Label("Send random", systemImage: Icons.sparkle.icon)
            //                    }
            ////                    .disabled(!isTesting)
            //                    .buttonStyle(.customButton(size: .small, /*status: isTesting ? .normal : .disabled,*/ labelDisplay: .titleOnly))
            

            Spacer()
            
            Button {
                Task {
                    await sendMessage()
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
