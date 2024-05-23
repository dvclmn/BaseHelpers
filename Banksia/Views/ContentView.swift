//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import Utilities
import SplitView
import Navigation
import Styles
import Popup
import Sidebar
import Grainient

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @Query private var conversations: [Conversation]
    
    @EnvironmentObject var nav: NavigationHandler<Page>
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var pref: Preferences
    
    var body: some View {
        
        @Bindable var bk = bk
        
        SplitView(nav: nav, popup: popup) {
            SidebarView()
        } content: { page in
            
            switch page {
            case .conversation(let conversationStatic):
                
                if let conversation = conversations.first(where: {$0.persistentModelID == conversationStatic.persistentModelID}) {
                    ConversationView(conversation: conversation)
                } else {
                    Text("No conversation")
                }

            }
            
        } toolbar: { page in
            
            switch page {
            case .conversation(let conversationStatic):
                
                if let conversation = conversations.first(where: {$0.persistentModelID == conversationStatic.persistentModelID}) {
                    ToolbarView(conversation: conversation)
                } else {
                    Text("No conversation")
                }

            }
            
        }
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
        .ignoresSafeArea()
        
        .grainient(
            seed: conv.grainientSeed,
            dimming: $bk.uiDimming
        )

        .onChange(of: conv.isRequestingNewConversation) {
            newConversation()
        }
        
    }
    
    
}

extension ContentView {
    func newConversation() {
        if conv.isRequestingNewConversation {
            let newGrainientSeed = GrainientSettings.generateGradientSeed()
            let newConversation = Conversation(name: "New conversation", grainientSeed: newGrainientSeed)
            modelContext.insert(newConversation)
            nav.path.append(Page.conversation(newConversation))
            popup.showPopup(title: "Added new conversation")
        }
        conv.isRequestingNewConversation = false
    }
}

#Preview {
    ContentView()
        .environment(ConversationHandler())
        .environment(BanksiaHandler())
        .environmentObject(NavigationHandler<Page>())
        .environmentObject(Preferences())
        .environmentObject(PopupHandler())
        .environmentObject(SidebarHandler())
        .modelContainer(try! ModelContainer.sample())
        .padding(.top,1)
        .frame(width: 600, height: 700)
}
