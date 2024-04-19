//
//  MessageInputView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
import Styles
import Utilities

struct MessageInputView: View {
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var pref: Preferences
    @Environment(\.modelContext) private var modelContext
    
    @SceneStorage("userPrompt") var userPrompt: String = ""
    
    @SceneStorage("editorHeight") var editorHeight: Double?
    
    @SceneStorage("isTesting") var isTesting: Bool = true
    
    @State private var isHoveringHeightAdjustor: Bool = false
    
    
    let minInputHeight: Double = 200
    let maxInputHeight: Double = 800
    
    let inputHeightControlSize: Double = 12
    
    
    @State private var trackedEditorHeight: Double = 0
    @GestureState private var dragState = CGSize.zero
    
    
    @FocusState private var isFocused
    
    var conversation: Conversation
    
    var body: some View {
        
        @Bindable var conv = conv
        
        VStack(spacing: 0) {
            
            
            
            VStack(alignment: .leading, spacing: 0) {
                
                //                TextEditor(text: $userPrompt)
                ScrollView(.vertical) {
                    StylableTextEditorRepresentable(text: $userPrompt)
                        .frame(minHeight: minInputHeight, maxHeight: .infinity)
//                        .border(Color.green.opacity(0.2))
//                        .focused($isFocused)
                }
                .frame(minHeight: editorHeight ?? minInputHeight, maxHeight: editorHeight ?? maxInputHeight)
                //                .mask {
                //                    VStack {
                //                        Color.clear
                //                            .frame(height:10)
                //                        SmoothLinearGradient(
                //                            from: .clear,
                //                            to: .black,
                //                            startPoint: .top,
                //                            endPoint: UnitPoint(x: 0.5, y: 0.1)
                //                        )
                //                    }
                //                }
                //                    .fixedSize(horizontal: false, vertical: true)
//                .background(isTesting ? .purple.opacity(0.02) : .black.opacity(0.3))
                .padding(.top, 18 + inputHeightControlSize)
                .padding(.horizontal, Styles.paddingText)
                .scrollContentBackground(.hidden)
//                .scrollIndicators(.hidden)
                .onChange(of: conv.isResponseLoading) {
                    isFocused = !conv.isResponseLoading
                    editorHeight = nil
                }
                .background(.plum)
                .overlay(alignment: .top) {
                    GeometryReader { geo in
                        //                            HStack {
                        //                                Text("\(geo.size.height)")
                        //                                Text("Tracked height: \(trackedEditorHeight)")
                        //                            }
                        Color(.blue.opacity(0.1))
                        //                            .overlay {
                        //                                Color(.white.opacity(isHoveringHeightAdjustor ? 0.2 : 0.1))
                        //                                .frame(height: isHoveringHeightAdjustor ? 12 : 2)
                        //                            }
                            .frame(height:inputHeightControlSize)
                            .contentShape(Rectangle())
                            .border(Color.green.opacity(0.2))
                            .gesture(
                                ExclusiveGesture(
                                    TapGesture(count: 2)
                                        .onEnded {
                                            editorHeight = nil
                                        }
                                    ,
                                    DragGesture(minimumDistance: 0)
                                    
                                    
                                        .onChanged { gesture in
                                            
                                            editorHeight = trackedEditorHeight
                                            
                                            editorHeight? += gesture.translation.height * -1
                                            editorHeight = min(max(editorHeight ?? 0, minInputHeight), maxInputHeight)
                                            
                                        }
                                )
                                
                            ) // END exclusive gesture
                            .cursor(.resizeUpDown)
                            .onHover { hovering in
                                withAnimation(Styles.animation) {
                                    isHoveringHeightAdjustor = hovering
                                }
                            }
                            .task(id: geo.size.height) {
                                trackedEditorHeight = geo.size.height
                            }
                    } // END geo
                    
                }
                
                
                
                
            } // END user text field hstack
            .overlay(alignment: .bottom) {
                HStack(spacing: 16) {
                    Spacer()
                    Toggle(isOn: $isTesting, label: {
                        Text("Test mode")
                    })
                    .foregroundStyle(isTesting ? .secondary : .quaternary)
                    .disabled(conv.isResponseLoading)
                    .toggleStyle(.switch)
                    .controlSize(.mini)
                    .tint(.secondary)
                    .animation(Styles.animationQuick, value: isTesting)
                    
                    Button(conv.isResponseLoading ? "Loading…" : "Send") {
                        
                        //                                        testScroll()
                        Task {
                            conv.isResponseLoading = true
                            await sendMessage(for: conversation)
                            conv.isResponseLoading = false
                            
                        }
                    }
                    .disabled(userPrompt.isEmpty)
                    .keyboardShortcut(.return, modifiers: .command)
                }
                .padding(.horizontal, Styles.paddingText)
                .padding(.top, 12)
                .padding(.bottom, 14)
                .background(.ultraThinMaterial)
                .grainOverlay(opacity: 0.4)
            }
            
            
            
            
            .onAppear {
                if isPreview {
                    userPrompt = ExampleText.basicMarkdown
                }
            }
            
            
            
        }
        
    }
    
    
    private func sendMessage(for conversation: Conversation) async {
        
        /// Save user message, so we can clear the input field
        let messageContents = userPrompt
        userPrompt = ""
        
        /// Create new `Message` object and add to database
        let newUserMessage = conv.createMessage(messageContents, with: .user, for: conversation)
        modelContext.insert(newUserMessage)
        
        /// Construct the message history for GPT context
        await conv.createMessageHistory(for: conversation, latestMessage: newUserMessage)
        
        do {
            let response: Message = try await conv.fetchGPTResponse(for: conversation, isTesting: isTesting)
            
            modelContext.insert(response)
            print(response.content)
            
            
        } catch {
            print("Error getting GPT response")
        }
        
    }
    
    
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
