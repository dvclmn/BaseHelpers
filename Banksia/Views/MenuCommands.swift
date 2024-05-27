//
//  MenuHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 7/2/2024.
//

import Foundation
import SwiftUI
import Sidebar

struct MenuCommands: Commands {

    @Binding var bk: BanksiaHandler
    @Binding var conv: ConversationHandler
    @ObservedObject var sidebar: SidebarHandler
    
    var body: some Commands {
        
        CommandGroup(replacing: .newItem) {
            Button("New") {
                conv.isRequestingNewConversation = true
            }
            .keyboardShortcut("n", modifiers: .command)
            
            Button("Quick Open…") {
                bk.isQuickNavShowing.toggle()
            }
            .keyboardShortcut("o", modifiers: .command)
            
            Button("Edit…") {
                conv.isConversationEditorShowing.toggle()
            }
            .keyboardShortcut("e", modifiers: .command)
            
            // TODO: Will need to conditionally turn the below shortcut off, so that I can delete lines w/ the same shortcut, in the Editor
//            Button("Delete Conversation…") {
//                
//            }
//            .keyboardShortcut(.delete, modifiers: .command)
        }
        
        CommandGroup(before: .toolbar) {
            Toggle(sidebar.isSidebarDismissed ? "Show Sidebar" : "Hide Sidebar", isOn: $sidebar.isSidebarDismissed)
                .keyboardShortcut("\\", modifiers: .command)
        }
        
        
        CommandGroup(before: .textEditing) {
            Button("Search…") {
                conv.isRequestingSearch = true
            }
            .keyboardShortcut("f", modifiers: .command)
        }
        
//        ToolbarCommands()
//        InspectorCommands()
    }
}
