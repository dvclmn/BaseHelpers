//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var prompt: String = """
    1. *Parent-Child Relationship:* Since you're planning to have the Conversation class as the main container, ensure that each UserPrompt and GPTResponse has a reference to its parent Conversation. This helps maintain the context of each entry and makes it easier to query all related prompts and responses for a given conversation.
    2. *Handling Edits and Deletions:* Consider how your model will handle edits or deletions. If a user edits a prompt or a response, how will this affect the sequence? Will you keep a history of changes, or will the edit simply replace the original?
    3. *Consistency and Integrity:* Ensure that the sequence of prompts and responses remains consistent and integral, especially if your application allows concurrent interactions or modifications to the conversation.
    """
    
    var body: some View {
        RichTextView(text: $prompt)
//        TwoColumnContentView()
            
    }
}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer.sample())
}
