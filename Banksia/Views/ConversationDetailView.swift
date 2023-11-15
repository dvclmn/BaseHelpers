/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 A view that displays the details of an animal.
 */

import SwiftUI
import SwiftData

struct ConversationDetailView: View {
    var conversation: Conversation?
    @State private var isDeleting = false
    @Environment(\.modelContext) private var modelContext
    @Environment(BanksiaHandler.self) private var bk
    
    var body: some View {
        if let conversation {
            ConversationDetailContentView(conversation: conversation)
                .navigationTitle("\(conversation.name)")
                .toolbar {
                    Button { isDeleting = true } label: {
                        Label("Delete \(conversation.name)", systemImage: "trash")
                            .help("Delete the animal")
                    }
                }
                .alert("Delete \(conversation.name)?", isPresented: $isDeleting) {
                    Button("Yes, delete \(conversation.name)", role: .destructive) {
                        delete(conversation)
                    }
                }
        } else {
            ContentUnavailableView("Select a conversation", systemImage: "message")
        }
    }
    
    private func delete(_ conversation: Conversation) {
        bk.currentConversation = nil
        modelContext.delete(conversation)
    }
}

private struct ConversationDetailContentView: View {
    let conversation: Conversation
    
    var body: some View {
        
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
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationDetailView(conversation: .plants)
            .environment(BanksiaHandler())
    }
}
