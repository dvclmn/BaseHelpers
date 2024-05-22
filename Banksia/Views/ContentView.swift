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

enum Page: Destination {
    
    case conversation(Conversation)
    
    var id: String {
        self.name
    }
    
    var name: String {
        switch self {
        case .conversation(let conversation):
            return conversation.name
        }
    }
    
    var icon: String {
        switch self {
        case .conversation(let conversation):
            return conversation.icon ?? Icons.message.icon
        }
    }
}

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var nav: NavigationHandler<Page>
    @EnvironmentObject var popup: PopupHandler
    
    var body: some View {
        
        @Bindable var bk = bk
        
        SplitView<Page, SidebarView, ToolbarView>(nav: nav, popup: popup) {
            SidebarView()
        } content: { page in
            
            switch page {
            case .conversation(let conversation):
                AnyView(ConversationView(conversation: conversation))
            }
            
        } toolbar: {
            ToolbarView()
            
        }
        
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
        .ignoresSafeArea()
        

        
//        .onChange(of: conv.isRequestingNewConversation) {
//            let newConversation = Conversation()
//            modelContext.insert(newConversation)
//            bk.selectedConversation = newConversation.persistentModelID
//        }
//        .onAppear {
//            if let firstConversation = conversations.first {
//                bk.selectedConversation = firstConversation.persistentModelID
//            }
//            //            getActiveConversation()
//        }
//        .onChange(of: bk.selectedConversation) {
//            //            getActiveConversation()
//        }
        
        //        .background(.contentBackground)
        
    }
    
    //    private func getActiveConversation() {
    //        print("Let's get the active conversation")
    //        if let conversationID = bk.selectedConversation.first {
    //            let conversation = conversations.first(where: {$0.persistentModelID == conversationID})
    //            print("The active conversation is: \(String(describing: conversation?.name))")
    //            bk.activeConversation = conversation
    //        }
    //    }
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
