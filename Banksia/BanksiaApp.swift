//
//  BanksiaApp.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI
import SwiftData

@main
struct BanksiaApp: App {
    
    @State private var bk = BanksiaHandler()
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
                .environment(bk)
                .environmentObject(pref)
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
        .commands {
            SidebarCommands()
            TextFormattingCommands()
            TextEditingCommands()
        }
        
#if os(macOS)
        Settings {
            SettingsView()
                .environment(bk)
                .environmentObject(pref)
        }
#endif
    }
    
}
