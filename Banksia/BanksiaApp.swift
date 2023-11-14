//
//  BanksiaApp.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI

@main
struct BanksiaApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Conversation.self)
        .commands {
            SidebarCommands()
        }
    }
}
