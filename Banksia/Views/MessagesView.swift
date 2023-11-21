//
//  MessagesView.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import SwiftUI

struct MessagesView: View {
    var conversation: Conversation
    @EnvironmentObject var bk: BanksiaHandler
    
    @State private var prompt: String = ""
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                Text(conversation.name)
                    .fontStyle(.largeTitle)
                    .padding()
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
                RichTextView(text: $prompt)
                #elseif os(iOS)
                TextField("Butts", text: $prompt)
                #endif
                Button("Send") {
                    bk.sendMessage(userMessage: prompt)
                }
            } // END user text field hstack
        } // END Vstack
        .navigationTitle("\(conversation.name)")
    }
}

#Preview {
    MessagesView(conversation: .childcare)
        .environmentObject(BanksiaHandler())
}
