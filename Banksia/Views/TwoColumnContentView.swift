//
//  TwoColumnContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI
import SwiftData

struct TwoColumnContentView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        @Bindable var bk = bk
        NavigationSplitView(columnVisibility: $bk.columnVisibility) {
            ConversationListView()
                .navigationTitle(bk.sidebarTitle)
                .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 260)
        } detail: {
            NavigationStack {
                ConversationDetailView(conversation: bk.selectedConversation)
            }
        }
        .toolbar {
            ToolbarItem() {
                Circle()
                    .fill(Color.random)
                    .frame(width:8, height:8)
                    .padding(8)
            }
            ToolbarItem() {
                Button(action: {
                    Conversation.insertSampleData(modelContext: modelContext)
                    try? modelContext.save()
                            }) {
                                Label("Add sample data", systemImage: "sparkles")
                            } // END button
            } // END add sample data
            
            ToolbarItem() {
                Button(action: {
                    bk.deleteAll(for: modelContext)
                    try? modelContext.save()
                            }) {
                                Label("Remove all", systemImage: "rays")
                            } // END button
            } // END delete all
        } // END toolbar
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TwoColumnContentView()
            .environment(BanksiaHandler())
    }
}
