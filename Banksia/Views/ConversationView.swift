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
    @Environment(\.modelContext) private var modelContext
    
    @Query private var conversations: [Conversation]
    
    init(filter: Predicate<Conversation>? = nil) {
            
            if let filter = filter {
                _conversations = Query(filter: filter)
            } else {
                _conversations = Query()
            }
        }
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            if let messages = conversations.first?.messages {
                
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 12) {
                            ForEach(messages.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                                
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
                    .defaultScrollAnchor(.bottom)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            withAnimation(Styles.animation){
                                scrollProxy.scrollTo("bottom")
                            }
                        } label: {
                            Label("Scroll to bottom", systemImage: Icons.arrowDown)
                                .labelStyle(.iconOnly)
                        }
                        .padding()
                    }
                } // END scroll reader
                
                
                
            } else {
                Text("No messages yet")
            } // END messages check
            
            if let conversation = conversations.first {
                MessageInputView(conversation: conversation)
            }
            
        } // END Vstack
//        .navigationTitle(conversation.name)
    }
    
}


#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationView()
            .environment(BanksiaHandler())
            .frame(width: 600, height: 700)
    }
}
