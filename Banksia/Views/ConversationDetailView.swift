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
    @Environment(NavHandler.self) private var navHandler

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
            ContentUnavailableView("Select an animal", systemImage: "pawprint")
        }
    }
    
    private func delete(_ conversation: Conversation) {
        navHandler.selectedConversation = nil
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
                            if let prompts = conversation.prompts {
                                ForEach(prompts, id: \.timestamp) { userPrompt in
                                    VStack(alignment: .leading) {
                                        Text(userPrompt.content)
                                            .padding()
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        if let response = userPrompt.response {
                                            Text(response.content)
                                                .padding()
                                                .background(Color.green.opacity(0.2))
                                                .cornerRadius(10)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                    }
                                } // END ForEach
                                
                            } else {
                                let _ = print("No prompts found")
                                Text("No prompts found")
                            } // END prompts check
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
            .environment(NavHandler())
    }
}
