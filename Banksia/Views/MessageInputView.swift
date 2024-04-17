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
    
    @State private var isHoveringHeightAdjustor: Bool = false
    
    let minInputHeight: Double = 200
    let maxInputHeight: Double = 600
    
    
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
                        .border(Color.green)
                        .focused($isFocused)
                }
                    .padding(.top)
                    .padding(.horizontal)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .frame(minHeight: editorHeight ?? minInputHeight, maxHeight: editorHeight ?? maxInputHeight)
                    .fixedSize(horizontal: false, vertical: true)
                    .onChange(of: conv.isResponseLoading) {
                        isFocused = !conv.isResponseLoading
                        editorHeight = nil
                    }
                    .overlay(alignment: .top) {
                        GeometryReader { geo in
                            //                            HStack {
                            //                                Text("\(geo.size.height)")
                            //                                Text("Tracked height: \(trackedEditorHeight)")
                            //                            }
                            Rectangle()
                                .fill(.blue.opacity(!isHoveringHeightAdjustor ? 0.3 : 0.0))
                                .frame(height: 10)
                                .contentShape(Rectangle())
                                .gesture(
                                    ExclusiveGesture(
                                        TapGesture(count: 2)
                                            .onEnded {
                                                editorHeight = nil
                                            }
                                        ,
                                        DragGesture(minimumDistance: 0)
                                        
                                        
                                            .onChanged { gesture in
                                                
                                                print(gesture.startLocation)
                                                print(gesture.translation)
                                                
                                                editorHeight = trackedEditorHeight
                                                
                                                editorHeight? += gesture.translation.height * -1
                                                editorHeight = min(max(editorHeight ?? 0, minInputHeight), maxInputHeight)
                                                
                                            }
                                    )
                                    
                                ) // END exclusive gesture
                                .cursor(.resizeUpDown)
                            //                                .onHover { hovering in
                            //                                    withAnimation(Styles.animation) {
                            //                                        isHoveringHeightAdjustor = hovering
                            //                                    }
                            //                                }
                                .task(id: geo.size.height) {
                                    trackedEditorHeight = geo.size.height
                                }
                        } // END geo
                        
                    }
                
                
                
                
            } // END user text field hstack
            .overlay(alignment: .bottom) {
                HStack(spacing: 16) {
                    Spacer()
                    Toggle(isOn: $conv.isTesting, label: {
                        Text("Test mode")
                    })
                    .foregroundStyle(conv.isTesting ? .secondary : .quaternary)
                    .disabled(conv.isResponseLoading)
                    .toggleStyle(.switch)
                    .controlSize(.mini)
                    .tint(.secondary)
                    .animation(Styles.animationQuick, value: conv.isTesting)
                    
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
                .padding(.horizontal, 14)
                .padding(.top, 12)
                .padding(.bottom, 14)
                .background(.ultraThinMaterial)
            }
            
            
            
            
            .background(.black.opacity(0.3))
            
            //            self.prompt = Message.prompt_02.content
            .onAppear {
                if isPreview {
                    userPrompt = bigText
                }
            }
            
            
            
        }
        
    }
    
    //    private func testScroll() {
    //        let newMessage = Message(content: pref.userPrompt)
    //        modelContext.insert(newMessage)
    //        newMessage.conversation = conversation
    //    }
    
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
            let response: Message = try await conv.fetchGPTResponse(for: conversation)
            
            modelContext.insert(response)
            
            
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
    .frame(width: 560, height: 700)
    .background(.contentBackground)
}
