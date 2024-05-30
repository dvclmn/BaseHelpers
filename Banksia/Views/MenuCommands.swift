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
import Sparkle

struct MenuCommands: Commands {
    
    @ObservedObject var bk: BanksiaHandler
    @Binding var conv: ConversationHandler
    @ObservedObject var sidebar: SidebarHandler
    
    let updaterController: SPUStandardUpdaterController
    
    var body: some Commands {
        
        CommandGroup(replacing: .newItem) {
            Button("New") {
                conv.currentRequest = .new
            }
            .keyboardShortcut(AppAction.new.shortcut)
            
            Button("Quick Open…") {
                AppAction.toggleQuickOpen(bk).action()
            }
            .keyboardShortcut(AppAction.toggleQuickOpen(bk).shortcut)
            
            Button("Edit…") {
                conv.isConversationEditorShowing.toggle()
            }
            .keyboardShortcut(AppAction.edit.shortcut)
        }
        
        
        // MARK: - View
        CommandGroup(before: .toolbar) {
            Button(sidebar.isSidebarDismissed ? "Show Sidebar" : "Hide Sidebar") {
                conv.currentRequest = .toggleSidebar(sidebar)
            }
            .keyboardShortcut(AppAction.toggleSidebar(sidebar).shortcut)
            
            Button(bk.isToolbarExpanded ? "Hide Expanded Toolbar" : "Show Expanded Toolbar") {
                conv.currentRequest = .toggleSidebar(sidebar)
            }
            .keyboardShortcut(AppAction.toggleToolbarExpanded(bk).shortcut)
            
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
            
//            Button("Previous Quick Open Conversation") {
//                conv.currentRequest = .goToPreviousQuickOpen
//            }
//            .disabled(!bk.isPreviousQuickOpenAvailable && !bk.isQuickOpenShowing)
//            .keyboardShortcut(.upArrow, modifiers: [])
//            
//            Button("Next Quick Open Conversation") {
//                conv.currentRequest = .goToNextQuickOpen
//            }
//            .disabled(!bk.isNextQuickOpenAvailable && !bk.isQuickOpenShowing)
//            .keyboardShortcut(.downArrow, modifiers: [])
            
            
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
            .keyboardShortcut(AppAction.search.shortcut)
        }
        
        
        CommandGroup(after: .appInfo) {
            CheckForUpdatesView(updater: updaterController.updater)
        }
        
        //        ToolbarCommands()
        //        InspectorCommands()
    }
}
