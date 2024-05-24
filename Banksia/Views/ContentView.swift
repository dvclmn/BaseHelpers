//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import Utilities
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
    @EnvironmentObject var sidebar: SidebarHandler
    
    var body: some View {
        
        @Bindable var bk = bk
        
        NavigationStack(path: $nav.path) {
            
            DetailView(conversations: conversations)
            
            .navigationDestination(for: Page.self) { page in
                
                DetailView(page: page, conversations: conversations)
                
            }
            
        }
        .frame(
            minWidth: sidebar.contentMinWidth,
            idealWidth: .infinity,
            maxWidth: .infinity,
            minHeight: Styles.minContentHeight,
            maxHeight: .infinity,
            alignment: .trailing
        )
        .readSize { size in
            sidebar.windowWidth = size.width
        }
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
        .grainient(
            seed: conv.grainientSeed,
            dimming: $bk.uiDimming
        )
        .ignoresSafeArea()
        
        .onAppear {
            if nav.path.isEmpty, let firstConversation = conversations.last {
                nav.path = [Page.conversation(firstConversation)]
            }
            
            // TODO: Need to get UI dimming preference working correctly
//            bk.uiDimming = pref.uiDimming
        }
        .onChange(of: conv.isRequestingNewConversation) {
            newConversation()
        }
//        .onChange(of: sidebar.isRequestingSidebar) {
//            
//            let widthDefecit: Double = (sidebar.sidebarWidth + sidebar.windowWidth)
//            
//            sidebar.contentMinWidth += (sidebar.sidebarWidth + sidebar.sidebarToggleBuffer)
////            if sidebar.isSidebarVisible {
//                sidebar.isRequestingSidebar = false
//                sidebar.contentMinWidth -= (sidebar.sidebarWidth + sidebar.sidebarToggleBuffer)
////            }
//        }
        
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
