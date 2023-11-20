//
//  BanksiaApp.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI

@main
struct BanksiaApp: App {
    @State var bk = BanksiaHandler()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bk)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Conversation.self, Message.self], isUndoEnabled: true)
        .commands {
            SidebarCommands()
        }
        
#if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(bk)
        }
#endif
    }
    
}
