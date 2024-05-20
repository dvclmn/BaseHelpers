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

@main
struct BanksiaApp: App {
    
    @StateObject private var popup = PopupHandler()
    @State private var nav = Navigation()
    @State private var bk = BanksiaHandler()
    @State private var conv = ConversationHandler()
    @StateObject private var pref = Preferences()
    
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
                .environmentObject(popup)
                .environment(nav)
                .environment(bk)
                .environment(conv)
                .environmentObject(pref)
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
//        .commands {
//            SidebarCommands()
//            TextFormattingCommands()
//            TextEditingCommands()
//        }
        .windowStyle(.hiddenTitleBar)
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
        }
#endif
    }
    
}
