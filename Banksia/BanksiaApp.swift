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
    
    @StateObject private var conv = ConversationHandler()
    @StateObject private var bk = BanksiaHandler()
    @StateObject private var nav = NavigationHandler()
    @StateObject private var popup = PopupHandler()
    @StateObject private var sidebar = SidebarHandler()
    
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        Window("Banksia", id: "main") {
            ContentView()
                .environmentObject(conv)
                .environmentObject(bk)
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
                updaterController: updaterController
            )
        }
        
#endif
        
            Window("Banksia Debug", id: "debug") {
                DebugView()
                    .environmentObject(conv)
                    .environmentObject(bk)
                    .environmentObject(nav)
                    .environmentObject(popup)
                    .environmentObject(sidebar)

            }
            .windowStyle(.hiddenTitleBar)
            .windowResizability(.contentSize)
        

        
        
#if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(bk)
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
