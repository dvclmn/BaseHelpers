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
import KeyboardShortcuts

@main
struct BanksiaApp: App {
    
    @State private var conv = ConversationHandler()
    @State private var bk = BanksiaHandler()
    @StateObject private var nav = NavigationHandler()
    @StateObject private var pref = Preferences()
    @StateObject private var popup = PopupHandler()
    @StateObject private var sidebar = SidebarHandler()
    
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        Window("Banksia", id: "main") {
            ContentView()
                .environment(conv)
                .environment(bk)
                .environmentObject(pref)
                .environmentObject(nav)
                .environmentObject(popup)
                .environmentObject(sidebar)
        }
        .modelContainer(for: Conversation.self, isUndoEnabled: true)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 800, height: 900)
#if os(macOS)
        .commands {
            MenuCommands(
                bk: bk,
                conv: conv,
                sidebar: sidebar,
                pref: pref,
                updaterController: updaterController
            )
        }
        
#endif
        
            Window("Banksia Debug", id: "debug") {
                DebugView()
                    .environment(conv)
                    .environment(bk)
                    .environmentObject(pref)
                    .environmentObject(nav)
                    .environmentObject(popup)
                    .environmentObject(sidebar)

            }
            .windowStyle(.hiddenTitleBar)
            .windowResizability(.contentSize)
        

        
        
#if os(macOS)
        Settings {
            SettingsView()
                .environment(bk)
                .environmentObject(pref)
                .environmentObject(popup)
                .environmentObject(sidebar)
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
