//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import GeneralUtilities
import Navigation
import GeneralStyles
import Popup
import Sidebar
import Grainient
import Swatches

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @Query private var conversations: [Conversation]
    
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var sidebar: SidebarHandler
    
    var body: some View {
        
        @Bindable var bk = bk
        
        NavigationStack(path: $nav.path) {
            
            DetailView()
            
            .navigationDestination(for: Page.self) { page in
                DetailView(page: page)
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
            sidebar.windowSize = size
        }
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
        .grainient(
            seed: conv.grainientSeed ?? pref.defaultGrainientSeed,
            dimming: $pref.uiDimming
        )
        .background(Swatch.slate.colour)
        .ignoresSafeArea()
        
        .onAppear {
            
//#if DEBUG
//
//            try? modelContext.delete(model: Conversation.self)
//
//#endif
//            
            if nav.path.isEmpty, let firstConversation = conversations.last {
                nav.path = [Page.conversation(firstConversation)]
            }
            if conversations.isEmpty {
                let grainientSeed = GrainientSettings.generateGradientSeed()
                let newConversation = Conversation(grainientSeed: grainientSeed)
                
                modelContext.insert(newConversation)
                
                nav.navigate(to: .conversation(newConversation))
            }

        }
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

#if DEBUG
#Preview {
    ContentView()
        .environment(ConversationHandler())
        .environment(BanksiaHandler())
        .environmentObject(NavigationHandler())
        .environmentObject(Preferences())
        .environmentObject(PopupHandler())
        .environmentObject(SidebarHandler())
        .modelContainer(try! ModelContainer.sample())
        .padding(.top,1)
        .frame(width: 560, height: 700)
}
#endif
