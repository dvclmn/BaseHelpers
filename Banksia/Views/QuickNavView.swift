//
//  QuickNavView.swift
//  Banksia
//
//  Created by Dave Coleman on 17/4/2024.
//

import SwiftUI
import SwiftData
import Styles

struct QuickNavView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    @Query private var conversations: [Conversation]
    
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    @State private var isSelected: Bool = false
    
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
        
        var currentIndex: String {
            guard let index = indexOfSelectedConversation() else {
                return "No index"
            }
            
            return index.description
        }
        
        ZStack {
            
            Color.black.opacity(0.3)
                .onTapGesture {
                    bk.isQuickNavShowing = false
                }
            
            VStack {
                VStack {
                    Text(currentIndex)
                    TextField("Search conversations", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 16))
                        .focused($isFocused)
                        .onAppear {
                            isFocused = true
                        }
                        .onSubmit {
                            bk.selectedConversation = self.selectedConversation?.persistentModelID
                        }
                        .onExitCommand {
                            bk.isQuickNavShowing = false
                        }
                    
                    
                    //                        List(selection: $selectedConversation) {
                    ForEach(filteredResults) { conversation in
                        
                        Button {
                            bk.selectedConversation = conversation.persistentModelID
                        } label: {
                            Label(conversation.name, systemImage: conversation.icon ?? "")
                            //                            .background(Color.blue)
                        }
                        .buttonStyle(.plain)
                        .background(conversation == self.selectedConversation ? .blue : .clear)
                        //                    .disabled(!isSelected)
                        //                                .keyboardShortcut(.return)
                        //                    .focused($isFocused)
                    }
                    
                    
                    Button("Down") {
                        moveToNextConversation()
                        print("Pressed down arrow, moved down")
                    }
                    .disabled(!canMoveToNextConversation())
//                    .keyboardShortcut(.downArrow)
                    
                    
                }
                .task(id: searchText) {
                    if searchText.count > 0 {
                        selectedConversation = filteredResults[0]
                    } else {
                        selectedConversation = firstResult
                    }
                }
                .frame(maxWidth: 400)
                .padding()
                .background(.contentBackground)
                .clipShape(RoundedRectangle(cornerRadius: Styles.roundingMedium))
                .padding(.top, 80)
                
                Spacer()
            } // END main vstack
            
        } // END zstack
    }
    
    private func indexOfSelectedConversation() -> Int? {
        guard let selectedConversation = selectedConversation else {
            return nil
        }
        return conversations.firstIndex(where: { $0.id == selectedConversation.id })
    }
    
    // Example usage of indexOfSelectedConversation
    //        private func deleteSelectedConversation() {
    //            guard let index = indexOfSelectedConversation() else {
    //                return
    //            }
    //            conversations.remove(at: index)
    //        }
    
    private func moveToNextConversation() {
            guard let currentIndex = indexOfSelectedConversation(), currentIndex < conversations.count - 1 else {
                return
            }
            selectedConversation = conversations[currentIndex + 1]
        }

        private func canMoveToNextConversation() -> Bool {
            guard let currentIndex = indexOfSelectedConversation() else {
                return false
            }
            return currentIndex < conversations.count - 1
        }
    
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        QuickNavView()
            .environment(BanksiaHandler())
    }
}
