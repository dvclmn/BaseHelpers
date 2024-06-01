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
    @EnvironmentObject var conv: ConversationHandler
    @EnvironmentObject var bk: BanksiaHandler
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Environment(\.modelContext) private var modelContext
    
//    @SceneStorage("userPrompt") var userPrompt: String = ""
    
    @State private var isUIFaded: Bool = false
    
    @FocusState private var isFocused
    
    @State private var isHoveringHeightAdjustor: Bool = false
    @State private var isHoveringControls: Bool = false
    
    @State private var isMasked: Bool = true
    @State private var isScrolling: Bool = false
    
    @State private var countdown = CountdownTimer()

    @Bindable var conversation: Conversation
    
    @Binding var userPrompt: String
    
    var body: some View {
        
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
                
//                Button {
//                    
//                } label: {
//                    Label("Add to Message", systemImage: Icons.plus.icon)
//                }
//                .offset(y: -30)
                
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
    
}

extension MessageInputView {
    @ViewBuilder
    func EditorControls() -> some View {
        HStack(spacing: 18) {
            
            
            
            Group {
                Label(bk.gptModel.name, systemImage: Icons.shocked.icon)
                Label("\(conv.totalTokens(for: conversation))", systemImage: Icons.token.icon)
            }
            .labelStyle(.customLabel(size: .mini))
            .padding(.leading, Styles.paddingNSTextViewCompensation)
            
            Spacer()
            
            Toggle(isOn: $bk.isTestMode, label: {
                Label("Test mode", systemImage: Icons.fish.icon)
                    .labelStyle(.customLabel(size: .small, labelDisplay: .titleOnly))
            })
            .foregroundStyle(bk.isTestMode ? .secondary : .quaternary)
            .disabled(conv.isResponseLoading)
            .toggleStyle(.switch)
            .controlSize(.mini)
            .tint(.secondary)
            .animation(Styles.animationQuick, value: bk.isTestMode)
            
            
            Button {
                Task {
                    conv.currentRequest = .sendQuery
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
                conversation: Conversation.childcare
            )
        }
    }
    .environmentObject(ConversationHandler())
    .environmentObject(BanksiaHandler())
    
    .environmentObject(SidebarHandler())
    .frame(width: 380, height: 700)
    .background(.contentBackground)
}
#endif
