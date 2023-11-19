//
//  TwoColumnContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI
import SwiftData

struct TwoColumnContentView: View {
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(\.modelContext) private var modelContext
    
    @State private var isDeleting: Bool = false
    
    var body: some View {
        NavigationSplitView(columnVisibility: $bk.sidebarVisibility) {
            ConversationListView(isDeleting: isDeleting)
                .navigationTitle("Conversations")
                .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 260)
        } detail: {
            NavigationStack {
                ConversationDetailView(isDeleting: isDeleting)
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
                HandyButton(label: "Add sample data", icon: "sparkles") {
                    Conversation.insertSampleData(modelContext: modelContext)
                    try? modelContext.save()
                }
            } // END add sample data
            
            ToolbarItem() {
                Button(action: {
                    bk.testAPIFetch()
                }) {
                    Label("Test API call", systemImage: "cursorarrow.rays")
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
            .environmentObject(BanksiaHandler())
    }
}
