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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Conversation.self,
            UserPrefs.self
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
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
        .commands {
            SidebarCommands()
        }
        
#if os(macOS)
        Settings {
            SettingsView()
                .environment(bk)
        }
#endif
    }
    
}
