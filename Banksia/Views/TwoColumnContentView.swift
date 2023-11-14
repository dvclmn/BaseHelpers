//
//  TwoColumnContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI
import SwiftData

struct TwoColumnContentView: View {
    @Environment(NavHandler.self) private var navHandler
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        @Bindable var navHandler = navHandler
        NavigationSplitView(columnVisibility: $navHandler.columnVisibility) {
            ConversationListView()
                .navigationTitle(navHandler.sidebarTitle)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            Conversation.insertSampleData(modelContext: modelContext)
                            try? modelContext.save()
                                    }) {
                                        Label("Add sample data", systemImage: "sparkles")
                                    } // END button
                    }
                    
                } // END toolbar
        } detail: {
            NavigationStack {
                ConversationDetailView(conversation: navHandler.selectedConversation)
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TwoColumnContentView()
            .environment(NavHandler())
    }
}
