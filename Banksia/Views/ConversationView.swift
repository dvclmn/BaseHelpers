//
//  ConversationView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData

struct ConversationView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @Environment(\.modelContext) private var modelContext
    
    @Query private var conversations: [Conversation]
    
    @State private var isConversationEditorShowing: Bool = false
    
    init(filter: Predicate<Conversation>? = nil) {
        
        if let filter = filter {
            _conversations = Query(filter: filter)
        } else {
            _conversations = Query()
        }
    }
    
    
    var body: some View {
        
        @Bindable var conv = conv
        
        if let conversation = conversations.first {
            VStack(spacing: 0) {
                if let messages = conversation.messages {
                    
                    var searchResults: [Message] {
                        messages.filter { message in
                            if conv.searchText.count > 1 {
                                return message.content.localizedCaseInsensitiveContains(conv.searchText)
                            } else {
                                return true
                            }
                        }
                    }
                    
                    ScrollViewReader { scrollProxy in
                        
                        ScrollView(.vertical) {
                            LazyVStack(spacing: 12) {
                                ForEach(searchResults.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                                    
                                    
                                    SingleMessageView(message: message)
                                    
                                        .onChange(of: messages.count) {
                                            withAnimation(Styles.animation){
                                                scrollProxy.scrollTo("bottom")
                                            }
                                        }
                                } // END ForEach
                                Text("Bottom").id("bottom")
                                    .opacity(0)
                            } // END lazy vstack
                            .scrollTargetLayout()
                            .padding()
                            
                        } // END scrollview
                        .searchable(text: $conv.searchText, isPresented: $conv.isSearching, prompt: Text("Search messages"))
                        .defaultScrollAnchor(.bottom)
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                withAnimation(Styles.animation){
                                    scrollProxy.scrollTo("bottom")
                                }
                            } label: {
                                Label("Scroll to bottom", systemImage: Icons.arrowDown.icon)
                                    .labelStyle(.iconOnly)
                            }
                            .padding()
                        }
                    } // END scroll reader
                    .cursor(.arrow)
                    
                    
                } else {
                    Text("No messages yet")
                } // END messages check
                
                if let conversation = conversations.first {
                    MessageInputView(conversation: conversation)
                }
                
            } // END Vstack
            .navigationTitle(conversation.name)
            .toolbar {
                ToolbarItem {
                    Button {
                        isConversationEditorShowing.toggle()
                    } label: {
                        Label("Edit conversation prompt", systemImage: Icons.edit.icon)
                    }
                }
            }
            .sheet(isPresented: $isConversationEditorShowing, content: {
                ConversationEditorView(conversation: conversation)
            })
            
        } else {
            Text("No conversations")
        } // END conversation first check
    }
    
}


#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        
        ContentView()
            .environment(BanksiaHandler())
            .environment(ConversationHandler())
            .environmentObject(Preferences())
            .frame(width: 460, height: 700)
        
    }
}
