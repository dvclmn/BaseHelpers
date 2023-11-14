/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that displays a data entry form for editing information about an animal.
*/

import SwiftUI
import SwiftData

struct ConversationEditor: View {
    let conversation: Conversation?
    
    private var editorTitle: String {
        conversation == nil ? "Add Conversation" : "Edit Conversation"
    }
    
    @State private var name = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let conversation {
                    // Edit the incoming animal.
                    name = conversation.name
                }
            }
            .padding()
            
        }
    }
    
    private func save() {
        if let conversation {
            // Edit the animal.
            conversation.name = name
        } else {
            // Add an animal.
            let newConversation = Conversation(name: name)
            modelContext.insert(newConversation)
        }
    }
}

#Preview("Add animal") {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationEditor(conversation: nil)
    }
}

#Preview("Edit conversation") {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationEditor(conversation: .plants)
    }
}
