//
//  MessagesView.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import SwiftUI
import SwiftData

struct MessagesView: View {
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
        .navigationTitle("\(conversations.first?.name ?? "")")
    }
    

}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ContentView()
            .environment(BanksiaHandler())
            .frame(width: 700, height: 700)
    }
}
