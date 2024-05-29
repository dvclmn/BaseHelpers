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
                conv.currentRequest = .new
            }
            .keyboardShortcut(ConversationAction.new.shortcut)
            
            Button("Quick Open…") {
                bk.toggleQuickOpen()
            }
            .keyboardShortcut(ConversationAction.quickOpen.shortcut)
            
            Button("Edit…") {
                conv.isConversationEditorShowing.toggle()
            }
            .keyboardShortcut(ConversationAction.edit.shortcut)
        }
        
        CommandGroup(before: .toolbar) {
            Button(sidebar.isSidebarDismissed ? "Show Sidebar" : "Hide Sidebar") {
                sidebar.toggleSidebar()
            }
            .keyboardShortcut("\\", modifiers: .command)
            
        }
        CommandMenu("Navigate") {
            
            Button("Previous Conversation") {
                conv.currentRequest = .goToPrevious
            }
            
            .keyboardShortcut("[", modifiers: [.command, .shift])
            
            Button("Next Conversation") {
                conv.currentRequest = .goToNext
            }
            
            .keyboardShortcut("]", modifiers: [.command, .shift])
            
            
            Divider()
            
            Button("Previous Quick Open Conversation") {
                conv.currentRequest = .goToPreviousQuickOpen
            }
            .disabled(!bk.isPreviousQuickOpenAvailable && !bk.isQuickOpenShowing)
            .keyboardShortcut(.upArrow, modifiers: [])
            
            Button("Next Quick Open Conversation") {
                conv.currentRequest = .goToNextQuickOpen
            }
            .disabled(!bk.isNextQuickOpenAvailable && !bk.isQuickOpenShowing)
            .keyboardShortcut(.downArrow, modifiers: [])
            
            
        }
        CommandGroup(after: .pasteboard) {
            
                Button("Delete Conversation…") {
                    conv.currentRequest = .delete
                }
                .disabled(conv.isEditorFocused && conv.currentConversationID == nil)
                .keyboardShortcut(.delete, modifiers: .command)
            
        }
        
        CommandGroup(before: .textEditing) {
            Button("Search…") {
                conv.currentRequest = .search
            }
            .keyboardShortcut("f", modifiers: .command)
        }
        
        //        ToolbarCommands()
        //        InspectorCommands()
    }
}
