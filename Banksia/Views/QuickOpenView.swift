//
//  QuickOpenView.swift
//  Banksia
//
//  Created by Dave Coleman on 17/4/2024.
//

import SwiftUI
import SwiftData
import GeneralStyles
import GeneralUtilities
import Navigation

struct QuickOpenView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var nav: NavigationHandler
    
    @Query private var conversations: [Conversation]
    
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    @State private var selectedConversation: Conversation? = nil
    
    var body: some View {
        
        @Bindable var bk = bk
        
        var filteredResults: [Conversation] {
            if searchText.count > 0 {
                return conversations.filter { conversation in
                    conversation.name.localizedCaseInsensitiveContains(searchText)
                }
            } else {
                return conversations
            }
        }
        
        var firstResult: Conversation? {
            filteredResults.first
        }
        
        
        ZStack {
            
            if bk.isQuickOpenShowing {
                Color.black.opacity(0.3)
                    .onTapGesture {
                        bk.toggleQuickOpen()
                    }
                    .transition(.opacity)
            }
            
            VStack {
                if bk.isQuickOpenShowing {
                    VStack {
                        TextField("Search conversations", text: $searchText)
                            .textFieldStyle(.plain)
                            .font(.system(size: 16))
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                            .onSubmit {
                                if let conversation = selectedConversation {
                                    nav.navigate(to: .conversation(conversation))
                                }
                            }
                            .onExitCommand {
                                bk.toggleQuickOpen()
                            }
                        
                        //                        List(selection: $selectedConversation) {
                        ForEach(filteredResults) { conversation in
                            
                            Button {
                                nav.navigate(to: .conversation(conversation))
                            } label: {
                                Label(conversation.name, systemImage: conversation.icon ?? "")
                            }
                            .buttonStyle(.plain)
                            .background(conversation == self.selectedConversation ? .blue : .clear)
                            //                    .disabled(!isSelected)
                            //                                .keyboardShortcut(.return)
                            //                    .focused($isFocused)
                        }
                        
                        
                        
                        
                    } // END inner Vstack
                    .task(id: searchText) {
                        if searchText.count > 0 && filteredResults.count > 0 {
                            selectedConversation = filteredResults.first
                        } else {
                            selectedConversation = firstResult
                        }
                    }
                    .frame(maxWidth: 400)
                    .padding()
                    .background(.contentBackground)
                    .clipShape(RoundedRectangle(cornerRadius: Styles.roundingMedium))
                    .padding(.top, 80)
                    .transition(.fadeSlide)
                    
                    
                    Spacer()
                } // END check for quick nav
                
            } // END main vstack
            .onAppear {
                if isPreview {
                    bk.toggleQuickOpen()
                }
            }
            .task(id: bk.isRequestingNextQuickOpenItem) {
                moveToNextConversation()
            }
            .task(id: bk.isRequestingPreviousQuickOpenItem) {
                moveToPreviousConversation()
            }
            .task(id: searchText) {
                bk.isNextQuickOpenAvailable = canMoveToNextConversation()
                bk.isPreviousQuickOpenAvailable = canMoveToPreviousConversation()
            }
        } // END zstack
    }
    
    private func indexOfSelectedConversation() -> Int? {
        guard let selectedConversation = selectedConversation else {
            return nil
        }
        print("Selected conversation Name: \(selectedConversation.name)")
        print("Selected conversation Created: \(selectedConversation.created)")
        
        let index: Int? = conversations.firstIndex(where: { $0.id == selectedConversation.id })
        print("Selected conversation Index: \(index?.description ?? "Invalid")")
        return index
    }
    
    private func moveToNextConversation() {
        if canMoveToNextConversation() {
            guard let currentIndex = indexOfSelectedConversation(), currentIndex < conversations.count - 1 else {
                return
            }
            selectedConversation = conversations[currentIndex + 1]
        }
    }
    
    private func moveToPreviousConversation() {
        if canMoveToPreviousConversation() {
            guard let currentIndex = indexOfSelectedConversation(), currentIndex > 0 else {
                return
            }
            selectedConversation = conversations[currentIndex - 1]
        }
    }
    
    private func canMoveToNextConversation() -> Bool {
        guard let currentIndex = indexOfSelectedConversation() else {
            return false
        }
        return currentIndex < conversations.count - 1
    }
    
    private func canMoveToPreviousConversation() -> Bool {
        guard let currentIndex = indexOfSelectedConversation() else {
            return false
        }
        return currentIndex > 0
    }
    
//    private enum Position {
//        case first, last
//    }
//
//    private func isItemInPosition<T: Collection>(index: T.Index, array: T, position: Position) -> Bool {
//        guard !array.isEmpty, array.indices.contains(index) else {
//            return false
//        }
//        switch position {
//        case .first:
//            return index == array.startIndex
//        case .last:
//            return index == array.index(before: array.endIndex)
//        }
//    }

}





#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        QuickOpenView()
            .environment(BanksiaHandler())
            .frame(width: 600, height: 700)
    }
}
