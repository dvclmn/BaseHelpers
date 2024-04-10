//
//  MessagesView.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import SwiftUI

struct MessagesView: View {
    var conversation: Conversation
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    @State private var prompt: String = ""
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    ForEach(conversation.messages.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                        VStack(alignment: .leading) {
                            Text(message.content)
                                .fontStyle(.body)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(message.isUser ? .blue : .gray))
                                .cornerRadius(10)
                        }
                    } // END ForEach
                } // END lazy vstack
                .padding()
            } // END scrollview
            
            HStack {
                #if os(macOS)
                TextEditor(text: $prompt)
//                RichTextView(text: $prompt)
                    .frame(minHeight: 200, maxHeight: 400)
                    
                #elseif os(iOS)
                TextField("Butts", text: $prompt)
                #endif
                Button("Send") {
                    bk.sendMessage(userMessage: prompt)
                }
                .keyboardShortcut(.return, modifiers: .command)
            } // END user text field hstack
        } // END Vstack
        .navigationTitle("\(conversation.name)")
    }
}

#Preview {
    MessagesView(conversation: .childcare)
        .environment(BanksiaHandler())
}
