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
    
    @State private var conversationIDToAddTextTo: Conversation.ID? = nil
    
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
                
                .frame(
                    minHeight: bk.editorHeight,
                    maxHeight: bk.editorHeight
                )
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
                    height: $bk.editorHeight,
                    maxHeight: sidebar.windowSize.height * 0.8
                )
                .onAppear {
                    conversationIDToAddTextTo = conversation.messages?.last?.persistentModelID
                }
                
                
                
                
            } // END user text field hstack
            
            // MARK: - Text area Buttons
            .overlay(alignment: .bottom) {
                
                Button {
                    addTextToMessage()
                } label: {
                    Label("Add to Message", systemImage: Icons.plus.icon)
                }
                
//                EditorControls()
//
//                    .onContinuousHover { phase in
//                        switch phase {
//                        case .active(_):
//                            isHoveringControls = true
//                        case .ended:
//                            isHoveringControls = false
//                        }
//                    }
            } // END input buttons overlay
            
            
            
            
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
    
    private func addTextToMessage() {
        let text = "Butts"
        
        guard let message = conversation.messages?.first(where: {$0.persistentModelID == conversationIDToAddTextTo}) else {
            print("No message to add text to")
            return
        }
        
        message.content += text
        
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
        bk.editorHeight = 180
        
        
        /// Construct the message history for GPT context
        let messageHistory: [RequestMessage] = await conv.createMessageHistory(
            for: conversation,
            latestMessage: newUserMessage,
            with: bk.systemPrompt
        )
        
        do {
            
            
            
            let requestBody = RequestBody(
                model: bk.gptModel.model,
                messages: messageHistory,
                stream: true,
                temperature: bk.gptTemperature
            )
            
            print("Final query to GPT:\n\(requestBody.messages)")
            
            let requestBodyData = APIHandler.encodeBody(requestBody)
            
            let request = try APIHandler.constructURLRequest(
                from: URL(string: OpenAIHandler.chatURL),
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
            
            
            
//            let (stream, _) = try await URLSession.shared.bytes(for: request)
//            print("Stream: \(stream)")
//            
//            
//            for try await line in stream.lines {
//                print("Entered the stream. \(line)")
//                guard let messageChunk = ConversationHandler.parse(line) else { continue }
//                
//                newGPTMessage.content += messageChunk
//            }
            
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
            //
            //
            
            
            
            
            
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
            .padding(.leading, 6)
            .symbolVariant(.fill)
            
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




//[
//    Banksia.RequestMessage(
//        role: "system",
//        content: "No need for lengthy intro and outro paragraphs, unless they provide useful info. Encouragement is OK, but avoid overly-cheery sentiment.\n\t•\tDo not repeat lengthy portions of my own code back to me, this wastes tokens, and I cannot afford to waste money\n\t•\tKeep answers to off-topic questions (not relating to coding) `brief`\n\t•\tMacro @Observable is part of the new Observation framework, introduced with iOS 17, and macOS 14. It is a robust & type-safe implementation of the observer design pattern in Swift. This is in place of ObservableObject, do not mix the two. Do not suggest or use ObservableObject unless asked specifically\n\t•\tSwiftData is the successor to Core Data, do not treat SwiftData as though it is a third party / unknown framework\n\t•\tDo not use Combine unless specifically requested. Instead prefer modern Swift concurrency, async/await, Task, etc."
//    ),
//    Banksia.RequestMessage(
//        role: "assistant",
//        content: "Sure, just send me the message when you\'re ready!"
//    ),
//    Banksia.RequestMessage(
//        role: "user",
//        content: "I am currently printing out arrays to the console in xcode, and they are difficult to read, as one run-on line. I\'d like to write  , and have the array print with line breaks and indentation, similar to the way the editor in xcode would display it. \"pretty printing\", essentuially. Can you write me a Swift extension on `Array` / `Collection`, such that I could write e.g. `print(\"My array: \\(myLongArrayExample.prettyPrinted)”)`, to achieve this?"
//    ),
//    Banksia.RequestMessage(
//        role: "assistant",
//        content: "Got it. How can I assist you today?"
//    ),
//    Banksia.RequestMessage(
//        role: "user",
//        content: "I am working on code to handle `Message` history (aka a context window), for my app Banksia. I am going to send you a short message, please send a short one back, so I can do some testing! Thanks"
//    )
//]

//[{"role": "system", "content" : "You are ChatGPT, a large language model trained by OpenAI. Answer as concisely as possible.\nKnowledge cutoff: 2021-09-01\nCurrent date: 2023-03-02"},
//{"role": "user", "content" : "How are you?"},
//{"role": "assistant", "content" : "I am doing well"},
//{"role": "user", "content" : "When was the last Formula One championship in South Africa?"},
//{"role": "assistant", "content" : "The last Formula One championship race held in South Africa was on October 17, 1993."},
//{"role": "user", "content" : "Who won the race in South Africa?"}]
