//
//  MenuHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 7/2/2024.
//

import Foundation
import SwiftUI
import Sidebar
import GeneralStyles

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
                bk.toggleQuickOpen()
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
            Button(sidebar.isSidebarDismissed ? "Show Sidebar" : "Hide Sidebar") {
                sidebar.toggleSidebar()
            }
            .keyboardShortcut("\\", modifiers: .command)
            
        }
        CommandMenu("Navigate") {
            
            Button("Previous Conversation") {
                bk.isRequestingNextQuickOpenItem = true
            }
            
            .keyboardShortcut("[", modifiers: [.command, .shift])
            
            Button("Next Conversation") {
                bk.isRequestingNextQuickOpenItem = true
            }
            
            .keyboardShortcut("]", modifiers: [.command, .shift])
            
            
            Divider()
            
            Button("Previous Quick Open Conversation") {
                bk.isRequestingNextQuickOpenItem = true
            }
            .disabled(!bk.isPreviousQuickOpenAvailable && !bk.isQuickOpenShowing)
            .keyboardShortcut(.upArrow, modifiers: [])
            
            Button("Next Quick Open Conversation") {
                bk.isRequestingNextQuickOpenItem = true
            }
            .disabled(!bk.isNextQuickOpenAvailable && !bk.isQuickOpenShowing)
            .keyboardShortcut(.downArrow, modifiers: [])
            
            
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
