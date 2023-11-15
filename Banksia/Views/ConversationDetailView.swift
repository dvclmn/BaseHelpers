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
        bk.selectedConversation = nil
        modelContext.delete(conversation)
    }
}

private struct ConversationDetailContentView: View {
    let conversation: Conversation
    
    var body: some View {
        
        VStack {
            Text(conversation.name)
                .font(.title)
                .padding()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    
                    ForEach(conversation.messages.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                            VStack(alignment: .leading) {
                                Text(message.content)
                                    .padding()
                                    .background(Color(message.isUser ? .blue : .gray))
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } // END ForEach
                        
                    
                } // END lazy vstack
                .padding()
            } // END scrollview
            .border(Color.green)
        } // END Vstack
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationDetailView(conversation: .plants)
            .environment(BanksiaHandler())
    }
}
