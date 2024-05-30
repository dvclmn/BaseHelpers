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
import Sparkle

@main
struct BanksiaApp: App {
    
    @State private var bk = BanksiaHandler()
    @State private var conv = ConversationHandler()
    
    @StateObject private var nav = NavigationHandler()
    @StateObject private var popup = PopupHandler()
    @StateObject private var pref = Preferences()
    @StateObject private var sidebar = SidebarHandler()
    
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
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
                sidebar: sidebar,
                updaterController: updaterController
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
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        
        
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
