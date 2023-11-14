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
