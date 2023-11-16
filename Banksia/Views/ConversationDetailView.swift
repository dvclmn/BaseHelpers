/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 A view that displays the details of an animal.
 */

import SwiftUI
import SwiftData

struct ConversationDetailView: View {
    var conversation: Conversation?
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(\.modelContext) private var modelContext
    
    var isDeleting: Bool
    
    @State private var prompt: String = ""
    
    var body: some View {
        if let conversation {
            VStack {
                ScrollView(.vertical) {
                    Text(conversation.name)
                        .font(.title)
                        .padding()
                    LazyVStack(spacing: 12) {
                        ForEach(conversation.messages.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                            VStack(alignment: .leading) {
                                Text(message.content)
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
                    RichTextView(text: $prompt)
                    Button("Send") {
                        bk.sendMessage(userMessage: prompt)
                    }
                } // END user text field hstack
            } // END Vstack
            .navigationTitle("\(conversation.name)")
            
        } else {
            ContentUnavailableView("Select a conversation", systemImage: "message")
        }
    }
    
    
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationDetailView(conversation: .plants, isDeleting: false)
            .environmentObject(BanksiaHandler())
    }
}
