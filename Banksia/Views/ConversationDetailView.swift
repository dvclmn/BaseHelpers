/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 A view that displays the details of an animal.
 */

import SwiftUI
import SwiftData

struct ConversationDetailView: View {
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(\.modelContext) private var modelContext
    
    var isDeleting: Bool
    
    @State private var prompt: String = """
    1. *Parent-Child Relationship:* Since you're planning to have the Conversation class as the main container, ensure that each UserPrompt and GPTResponse has a reference to its parent Conversation. This helps maintain the context of each entry and makes it easier to query all related prompts and responses for a given conversation.
    2. *Handling Edits and Deletions:* Consider how your model will handle edits or deletions. If a user edits a prompt or a response, how will this affect the sequence? Will you keep a history of changes, or will the edit simply replace the original?
    3. *Consistency and Integrity:* Ensure that the sequence of prompts and responses remains consistent and integral, especially if your application allows concurrent interactions or modifications to the conversation.
        ```swift
        func clampZoomLevel(isZoomIn: Bool) -> CGFloat {
            let increment = isZoomIn ? zoomIncrement : -zoomIncrement
            let newZoomLevel = currentZoomLevel + increment
            let clampedZoomLevel = min(max(newZoomLevel, zoomMin), zoomMax)

            // Check if clamping has occurred
            if isZoomIn {
                // Zooming in
                zoomClampActive = newZoomLevel > clampedZoomLevel || currentZoomLevel >= zoomMax
            } else {
                // Zooming out
                zoomClampActive = newZoomLevel < clampedZoomLevel || currentZoomLevel <= zoomMin
            }

            print(zoomClampActive.description)

            return clampedZoomLevel
        }
        ```
        
        In this updated function:

        The increment is determined based on whether the user is zooming in or out.
        The zoomClampActive is set to true if the new zoom level is outside the clamped range or if the currentZoomLevel is already at the zoomMin or zoomMax.
        This approach should ensure that zoomClampActive is set to true every time the user attempts to zoom beyond the allowed range, including when already at the minimum or maximum zoom level.
    """
    
    var body: some View {
        
        if let conversationSet = bk.currentConversations, conversationSet.count == 1 {
                            let conversation = conversationSet.first!
            VStack(spacing:0) {
                ScrollView(.vertical) {
                    //                    Text(conversation.name)
                    //                        .font(.title)
                    //                        .padding()
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(conversation.messages.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                            VStack(alignment: .leading) {
                                Text(message.content)
                                    .fontStyle(.body)
                                    .padding()
                                //                                    .frame(maxWidth: .infinity)
                                    .background(Color(message.isUser ? .blue : .gray.opacity(0.2)))
                                    .cornerRadiusWithBorder(radius: bk.cornerRadiusLarge, borderLineWidth: 2, borderColor: message.isUser ?  Color.indigo.opacity(0) : Color.gray.opacity(0.2))
                            }
                        } // END ForEach
                    } // END lazy vstack
                    .padding()
                } // END scrollview
                .border(Color.cyan.opacity(0.4))
                
                HStack {
                    RichTextView(text: $prompt)
                        .frame(maxWidth:.infinity, maxHeight:300)
                        .border(Color.cyan.opacity(0.4))
                    Button("Send") {
                        bk.sendMessage(userMessage: prompt)
                    }
                } // END user text field hstack
                .frame(maxHeight:200)
            } // END Vstack
            .navigationTitle("\(conversation.name)")
        
            
                            
        } else {
            Text("Multiple conversations selected")
        }
        
        
           
    }
    
    
}

#Preview(traits: .fixedLayout(width: 600, height: 500)) {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationDetailView(conversation: [.plants], isDeleting: false)
            .environmentObject(BanksiaHandler())
    }
}

