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
    
    @StateObject private var nav = NavigationHandler()
    @StateObject private var popup = PopupHandler()
    @StateObject private var pref = Preferences()
    @StateObject private var sidebar = SidebarHandler()
    
    var body: some Scene {
        Window("Banksia", id: "main") {
            ContentView()
                .environment(bk)
                .environment(conv)
                .environmentObject(nav)
                .environmentObject(pref)
                .environmentObject(popup)
                .environmentObject(sidebar)
        }
        .modelContainer(for: Conversation.self, isUndoEnabled: true)
        //        .commands {
        //            SidebarCommands()
        //            TextFormattingCommands()
        //            TextEditingCommands()
        //        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 800, height: 900)
#if os(macOS)
        .commands {
            MenuCommands(
                bk: $bk,
                conv: $conv,
                sidebar: sidebar
            )
        }
        
#endif
        Window("Banksia Debug", id: "debug") {
            DebugView()
                .environment(bk)
                .environment(conv)
                .environmentObject(nav)
                .environmentObject(pref)
                .environmentObject(popup)
                .environmentObject(sidebar)

        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.automatic)
        .defaultSize(width: 300, height: 400)

        
        
#if os(macOS)
        Settings {
            SettingsView()
                .environment(bk)
                .environmentObject(popup)
                .environmentObject(pref)
                .task {
                    let window = NSApplication.shared.keyWindow
                    window?.titlebarAppearsTransparent = true
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
#endif
    }
    
}
