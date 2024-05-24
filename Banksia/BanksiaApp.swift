//
//  BanksiaApp.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI
import SwiftData
import Popup
import Navigation
import Sidebar

@main
struct BanksiaApp: App {
    
    @State private var bk = BanksiaHandler()
    @State private var conv = ConversationHandler()
    
    @StateObject private var nav = NavigationHandler<Page>()
    @StateObject private var popup = PopupHandler()
    @StateObject private var pref = Preferences()
    @StateObject private var sidebar = SidebarHandler()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Conversation.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bk)
                .environment(conv)
                .environmentObject(nav)
                .environmentObject(pref)
                .environmentObject(popup)
                .environmentObject(sidebar)
        }
        .modelContainer(sharedModelContainer)
        //        .commands {
        //            SidebarCommands()
        //            TextFormattingCommands()
        //            TextEditingCommands()
        //        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
#if os(macOS)
        .commands {
            MenuCommands(
                bk: $bk,
                conv: $conv
            )
        }
#endif
        
#if os(macOS)
        Settings {
            SettingsView()
                .environment(bk)
                .environmentObject(pref)
                .task {
                    let window = NSApplication.shared.keyWindow
                    window?.toolbarStyle = .unified
                    window?.titlebarAppearsTransparent = true
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
#endif
    }
    
}
